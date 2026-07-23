variable "acr_name" {
  type        = string
  description = "Name of the existing Azure Container Registry"
  default     = "crazure3tierdev"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}
