output "resource_group_name" {
  value       = module.resource_group.name
  description = "Deployed Azure Resource Group Name"
}

output "frontend_url" {
  value       = module.compute.frontend_url
  description = "Public HTTP URL of Tier 1 Frontend SPA"
}

output "backend_url" {
  value       = module.compute.backend_url
  description = "HTTPS Endpoint of Tier 2 Backend API"
}

output "container_registry_name" {
  value       = module.container_registry.login_server
  description = "Azure Container Registry Login Server"
}

output "postgresql_fqdn" {
  value       = module.database.fqdn
  description = "Fully Qualified Domain Name of Azure PostgreSQL Database"
}
