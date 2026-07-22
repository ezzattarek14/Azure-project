output "frontend_url" {
  value       = "https://${azurerm_container_app.frontend.ingress[0].fqdn}"
  description = "Public URL of Tier 1 Frontend SPA"
}

output "backend_url" {
  value       = "https://${azurerm_container_app.backend.ingress[0].fqdn}"
  description = "URL of Tier 2 Backend API"
}

output "backend_app_id" {
  value       = azurerm_container_app.backend.id
  description = "Backend Container App Resource ID"
}
