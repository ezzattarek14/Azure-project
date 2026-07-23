output "id" {
  value       = data.azurerm_container_registry.acr.id
  description = "ACR resource ID"
}

output "login_server" {
  value       = data.azurerm_container_registry.acr.login_server
  description = "ACR login server URL"
}

output "admin_username" {
  value       = data.azurerm_container_registry.acr.admin_username
  description = "ACR admin username"
}

output "admin_password" {
  value       = data.azurerm_container_registry.acr.admin_password
  sensitive   = true
  description = "ACR admin password"
}

output "identity_id" {
  value       = azurerm_user_assigned_identity.acr_identity.id
  description = "Managed Identity ID"
}

output "identity_client_id" {
  value       = azurerm_user_assigned_identity.acr_identity.client_id
  description = "Managed Identity Client ID"
}
