# =========================================================
# Azure 3-Tier Architecture Infrastructure - Root Module
# =========================================================

# Local Naming Variables (Strict Enterprise Convention)
locals {
  resource_group_name = "rg-${var.app_name}-${var.environment}-${var.location}"
  vnet_name           = "vnet-${var.app_name}-${var.environment}"
  acr_name            = "crazure3tierdev"
  db_server_name      = "psql-${var.app_name}-${var.environment}"
}

# 1. Resource Group Module
module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = local.resource_group_name
  location            = var.location
  tags                = var.tags
}

# 2. Networking Module (VNet, Subnets, NSGs)
module "networking" {
  source              = "./modules/networking"
  vnet_name           = local.vnet_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = var.tags

  depends_on = [module.resource_group]
}

# 3. Container Registry Module (ACR + Managed Identity)
module "container_registry" {
  source                  = "./modules/container_registry"
  acr_name                = local.acr_name
  acr_resource_group_name = var.acr_resource_group_name
  location                = module.resource_group.location
  resource_group_name     = module.resource_group.name
  environment             = var.environment
  tags                    = var.tags

  depends_on = [module.resource_group]
}

# 4. Managed Database Module (Azure PostgreSQL Flexible Server)
module "database" {
  source              = "./modules/database"
  server_name         = local.db_server_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  vnet_id             = module.networking.vnet_id
  db_subnet_id        = module.networking.db_subnet_id
  admin_username      = var.db_admin_username
  admin_password      = var.db_admin_password
  tags                = var.tags

  depends_on = [module.networking]
}

# 5. Monitoring Module (Log Analytics, App Insights, Action Group)
module "monitoring" {
  source              = "./modules/monitoring"
  app_name            = var.app_name
  environment         = var.environment
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = var.tags

  depends_on = [module.resource_group]
}

# 6. Compute Module (Azure Container Apps Environment + Apps + Metric Alert)
module "compute" {
  source                     = "./modules/compute"
  app_name                   = var.app_name
  environment                = var.environment
  location                   = module.resource_group.location
  resource_group_name        = module.resource_group.name
  backend_subnet_id          = module.networking.backend_subnet_id
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  action_group_id            = module.monitoring.action_group_id
  acr_login_server           = module.container_registry.login_server
  acr_managed_identity_id    = module.container_registry.identity_id
  container_image_tag        = var.container_image_tag
  db_fqdn                    = module.database.fqdn
  db_user                    = module.database.admin_username
  db_password                = var.db_admin_password
  db_name                    = module.database.database_name
  tags                       = var.tags

  depends_on = [module.networking, module.container_registry, module.database, module.monitoring]
}
