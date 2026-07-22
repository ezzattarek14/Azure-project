variable "acr_name_prefix" {
  type        = string
  description = "Prefix for Azure Container Registry name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "sku" {
  type        = string
  description = "ACR SKU (Basic, Standard, Premium)"
  default     = "Basic"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}
