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
  description = "Resource group name"
}

variable "alert_email" {
  type        = string
  description = "Email address to receive alert notifications"
  default     = "devops-alerts@example.com"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}
