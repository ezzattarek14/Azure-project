variable "acr_name" {
  type        = string
  description = "Name of the existing Azure Container Registry"
  default     = "crazure3tierdev"
}

variable "acr_resource_group_name" {
  type        = string
  description = "Resource group name where existing ACR is located"
  default     = "rg-azure3tier-dev"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for managed identity"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}
