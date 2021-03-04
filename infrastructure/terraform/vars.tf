variable "project" {
  type        = string
  description = "GCP project ID"
}

variable "env" {
  description = "Environment"
  default = "dev"
}

variable "region" {
  description = "Default region for services and compute resources"
}

variable "zone" {
  description = "Default zone for services and compute resources"
}

variable "enable_active_components" {
  type        = bool
  description = "Boolean that indicates whether active components should be deployed, e.g., Cloud Run jobs"
  default     = true
}