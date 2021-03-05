locals {
  module_name = "speech-api"
}

######################################
# IAM
######################################

# [IAM] Service account
# Service account for the Dataflow job
resource "google_service_account" "sa" {
  project      = var.project
  account_id   = "sa-${local.module_name}-${var.env}"
  display_name = "SA for the ${local.module_name}"
}

# [IAM] Policy
# Policy to grant cloud run invoker to all users
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

######################################
# Cloud Run
######################################

# [Cloud Run] Service
# Start API in Cloud Run using the specific image
resource "google_cloud_run_service" "speech_api" {

  count = var.enable_speech_api ? 1 : 0

  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service
  name     = "${local.module_name}-${var.env}"
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.sa.email

      containers {
        # Fixed to specific version, should be deployed via CI/CD
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

# [Cloud Run] Policy
# Grant all users ability to invoke the API
resource "google_cloud_run_service_iam_policy" "noauth" {

  count = var.enable_speech_api ? 1 : 0

  location    = google_cloud_run_service.speech_api[0].location
  project     = google_cloud_run_service.speech_api[0].project
  service     = google_cloud_run_service.speech_api[0].name

  policy_data = data.google_iam_policy.noauth.policy_data
}