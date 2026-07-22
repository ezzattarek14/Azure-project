variable "app_name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}

variable "backend_subnet_id" {
  type        = string
  description = "Backend Subnet ID"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID"
}

variable "action_group_id" {
  type        = string
  description = "Monitor Action Group ID for alerts"
}

variable "acr_login_server" {
  type        = string
  description = "ACR login server URL"
}

variable "acr_managed_identity_id" {
  type        = string
  description = "User assigned Managed Identity ID for ACR pull"
}

variable "container_image_tag" {
  type        = string
  description = "Tag of the container image to run"
  default     = "latest"
}

variable "db_fqdn" {
  type        = string
  description = "PostgreSQL FQDN"
}

variable "db_user" {
  type        = string
  description = "PostgreSQL user"
}

variable "db_password" {
  type        = string
  description = "PostgreSQL password"
  sensitive   = true
}

variable "db_name" {
  type        = string
  description = "PostgreSQL database name"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}
