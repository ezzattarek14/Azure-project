variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "vnet_address_space" {
  type        = string
  description = "VNet CIDR block"
  default     = "10.0.0.0/16"
}

variable "frontend_subnet_prefix" {
  type        = string
  description = "Frontend Subnet CIDR block"
  default     = "10.0.1.0/24"
}

variable "backend_subnet_prefix" {
  type        = string
  description = "Backend Subnet CIDR block"
  default     = "10.0.2.0/24"
}

variable "db_subnet_prefix" {
  type        = string
  description = "Database Subnet CIDR block"
  default     = "10.0.3.0/24"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}
