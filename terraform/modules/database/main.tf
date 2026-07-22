# =========================================================
# Database Module: Azure Database for PostgreSQL Flexible Server
# =========================================================

resource "random_password" "pg_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Private DNS Zone for internal Database Resolution
resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_link" {
  name                  = "postgres-dns-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = var.vnet_id
}

# PostgreSQL Flexible Server (Tier 3 Managed DB)
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = var.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "16"
  administrator_login    = var.admin_username
  administrator_password = var.admin_password != "" ? var.admin_password : random_password.pg_password.result

  storage_mb = 32768 # 32GB (Smallest tier for Free/Low Cost)

  sku_name = "B_Standard_B1ms" # Burstable 1 vCPU, 2GB RAM (Free Tier eligible)
  zone     = "1"

  delegated_subnet_id = var.db_subnet_id
  private_dns_zone_id = azurerm_private_dns_zone.postgres_dns.id

  tags = var.tags

  depends_on = [azurerm_private_dns_zone_virtual_network_link.dns_vnet_link]
}

# Default Database
resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# Enforce SSL/TLS 1.2
resource "azurerm_postgresql_flexible_server_configuration" "require_ssl" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  value     = "on"
}
