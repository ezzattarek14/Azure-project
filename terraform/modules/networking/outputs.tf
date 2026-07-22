output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "Virtual Network ID"
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Virtual Network Name"
}

output "frontend_subnet_id" {
  value       = azurerm_subnet.frontend_subnet.id
  description = "Frontend Subnet ID"
}

output "backend_subnet_id" {
  value       = azurerm_subnet.backend_subnet.id
  description = "Backend Subnet ID"
}

output "db_subnet_id" {
  value       = azurerm_subnet.db_subnet.id
  description = "Database Subnet ID"
}
