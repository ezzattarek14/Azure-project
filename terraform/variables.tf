variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, staging, prod)"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Azure region for resource deployment"
  default     = "eastus"
}

variable "app_name" {
  type        = string
  description = "Application name prefix used across all resources"
  default     = "azure3tier"
}

variable "db_admin_username" {
  type        = string
  description = "Administrator username for PostgreSQL Flexible Server"
  default     = "pgadmin"
}

variable "db_admin_password" {
  type        = string
  description = "Administrator password for PostgreSQL Flexible Server"
  sensitive   = true
  default     = "P@ssw0rd123456!" # Override in production via secret store or environment variable
}

variable "container_image_tag" {
  type        = string
  description = "Docker container image tag to deploy"
  default     = "latest"
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to all Azure resources"
  default = {
    Project     = "Azure-3Tier-DevOps-Assessment"
    ManagedBy   = "Terraform"
    Environment = "dev"
    Owner       = "DevOps-Team"
  }
}
