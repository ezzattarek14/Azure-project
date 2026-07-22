output "server_id" {
  value       = azurerm_postgresql_flexible_server.postgres.id
  description = "PostgreSQL Server ID"
}

output "fqdn" {
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
  description = "PostgreSQL Server FQDN"
}

output "database_name" {
  value       = azurerm_postgresql_flexible_server_database.db.name
  description = "PostgreSQL Database Name"
}

output "admin_username" {
  value       = azurerm_postgresql_flexible_server.postgres.administrator_login
  description = "PostgreSQL Admin Username"
}
