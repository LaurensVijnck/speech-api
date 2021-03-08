variable "project" {
  type        = string
  description = "GCP project ID"
}

variable "env" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "region" {
  type        = string
  description = "Default region for services and compute resources"
}

variable "zone" {
  type        = string
  description = "Default zone for services and compute resources"
}