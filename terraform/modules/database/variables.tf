variable "server_name" {
  type        = string
  description = "PostgreSQL Flexible Server Name"
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "devops_db"
}

variable "location" {
  type        = string
  description = "Azure location"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "vnet_id" {
  type        = string
  description = "Virtual Network ID"
}

variable "db_subnet_id" {
  type        = string
  description = "Database Subnet ID"
}

variable "admin_username" {
  type        = string
  description = "PostgreSQL Administrator Username"
}

variable "admin_password" {
  type        = string
  description = "PostgreSQL Administrator Password"
  sensitive   = true
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}
