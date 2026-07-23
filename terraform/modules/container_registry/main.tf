# =========================================================
# Container Registry Module: Azure Container Registry (ACR)
# =========================================================

# Reference existing ACR located in specified ACR resource group
data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.acr_resource_group_name
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
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.acr_identity.principal_id
}
