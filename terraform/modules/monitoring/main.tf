# =========================================================
# Monitoring Module: Log Analytics, App Insights, & Action Group
# =========================================================

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "log-${var.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# Azure Application Insights
resource "azurerm_application_insights" "appinsights" {
  name                = "appi-${var.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.law.id
  application_type    = "web"
  tags                = var.tags
}

# Action Group for Alert Notifications
resource "azurerm_monitor_action_group" "devops_alerts" {
  name                = "ag-devops-alerts-${var.environment}"
  resource_group_name = var.resource_group_name
  short_name          = "DevOpsAlert"

  email_receiver {
    name                    = "DevOpsLead"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }

  tags = var.tags
}
