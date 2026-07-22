# =========================================================
# Container Registry Module: Azure Container Registry (ACR)
# =========================================================

# Random string suffix for globally unique ACR name
resource "random_string" "acr_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name_prefix}${random_string.acr_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku # Basic SKU is free-tier / budget friendly
  admin_enabled       = true    # Enables credentials fallback for Container Apps
  tags                = var.tags
}

# User-Assigned Managed Identity for secure non-root Pull access
resource "azurerm_user_assigned_identity" "acr_identity" {
  name                = "id-acr-pull-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Role Assignment: Grant AcrPull to Managed Identity (Least Privilege)
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.acr_identity.principal_id
}
