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


######################################
# Cloud Run
######################################
# Start API in Cloud Run using the specific image
resource "google_cloud_run_service" "speech_api" {
  count = var.enable_speech_api ? 1 : 0

  name     = "${local.module_name}-${var.env}"
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.sa.email

      containers {
        image = "eu.gcr.io/geometric-ocean-284614/speech-api:v1.0.0"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  lifecycle {
    # block destruction to avoid removal of unique endpoint
    prevent_destroy = true
  }
}