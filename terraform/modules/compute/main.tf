# =========================================================
# Compute Module: Azure Container Apps Environment & Apps
# =========================================================

# Container Apps Managed Environment
resource "azurerm_container_app_environment" "env" {
  name                       = "cae-${var.app_name}-${var.environment}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  infrastructure_subnet_id   = var.backend_subnet_id

  tags = var.tags
}

# Backend Container App (Tier 2 API)
resource "azurerm_container_app" "backend" {
  name                         = "ca-backend-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [var.acr_managed_identity_id]
  }

  registry {
    server   = var.acr_login_server
    identity = var.acr_managed_identity_id
  }

  template {
    container {
      name   = "backend-api"
      image  = var.container_image_tag == "bootstrap" ? "mcr.microsoft.com/azuredocs/aci-helloworld:latest" : "${var.acr_login_server}/backend-api:${var.container_image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "NODE_ENV"
        value = "production"
      }
      env {
        name  = "PORT"
        value = "5000"
      }
      env {
        name  = "DB_HOST"
        value = var.db_fqdn
      }
      env {
        name  = "DB_PORT"
        value = "5432"
      }
      env {
        name  = "DB_USER"
        value = var.db_user
      }
      env {
        name  = "DB_PASSWORD"
        value = var.db_password
      }
      env {
        name  = "DB_NAME"
        value = var.db_name
      }
      env {
        name  = "DB_SSL"
        value = "true"
      }

      readiness_probe {
        transport = "HTTP"
        port      = 5000
        path      = "/ready"
      }

      liveness_probe {
        transport = "HTTP"
        port      = 5000
        path      = "/health"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 5000
    transport        = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = var.tags
}

# Frontend Container App (Tier 1 SPA)
resource "azurerm_container_app" "frontend" {
  name                         = "ca-frontend-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [var.acr_managed_identity_id]
  }

  registry {
    server   = var.acr_login_server
    identity = var.acr_managed_identity_id
  }

  template {
    container {
      name   = "frontend-spa"
      image  = var.container_image_tag == "bootstrap" ? "mcr.microsoft.com/azuredocs/aci-helloworld:latest" : "${var.acr_login_server}/frontend-spa:${var.container_image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"

      readiness_probe {
        transport = "HTTP"
        port      = 80
        path      = "/"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    transport        = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = var.tags

  depends_on = [azurerm_container_app.backend]
}

# Example Requirement D: Azure Monitor Metric Alert for High CPU Utilization
resource "azurerm_monitor_metric_alert" "high_cpu_alert" {
  name                = "alert-${var.app_name}-high-cpu-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_container_app.backend.id]
  description         = "Triggered when backend API container CPU usage exceeds 80% threshold over 5 minutes."
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.App/containerApps"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}
