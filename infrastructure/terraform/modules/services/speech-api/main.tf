locals {
  module_name = "speech-api"
}

######################################
# IAM
######################################

# [AIM] Service account
# Service account for the Dataflow job
resource "google_service_account" "sa" {
  project      = var.project
  account_id   = "sa-${local.module_name}-${var.env}"
  display_name = "SA for the ${local.module_name}"
}