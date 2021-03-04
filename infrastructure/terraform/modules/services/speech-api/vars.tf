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

variable "enable_speech_api" {
  type        = bool
  description = "Boolean that indicates whether the speech API should be created"
  default     = true
}