locals {
  module_name = "cr-speech-api"
}

######################################
# IAM
######################################

# [IAM] Service account
# Service account for the speech-api cloud run instance
resource "google_service_account" "sa_speech_api" {
  project      = var.project
  account_id   = "sa-${local.module_name}-${var.env}"
  display_name = "SA for the ${local.module_name} Cloud Run Instance"
}

# [IAM] Service account
# Service account for API gateway
resource "google_service_account" "sa_api_gateway" {
  project      = var.project
  account_id   = "sa-api-gateway-${var.env}"
  display_name = "SA for the API Gateway"
}

# [IAM] Policy
# Policy to grant cloud run invoker to the API gateway SA
data "google_iam_policy" "sa_api_gateway_speech_access" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:${google_service_account.sa_api_gateway.email}",
    ]
  }
}

######################################
# Cloud Run
######################################

# [Cloud Run] Service
# Start API in Cloud Run using the specific image
resource "google_cloud_run_service" "speech_api" {

  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service
  name     = "${local.module_name}-${var.env}"
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.sa_speech_api.email

      containers {
        # Fixed to specific version, should be deployed via CI/CD
        image = "eu.gcr.io/${var.project}/speech-api:v1.0.2"
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
# Grant api gateway to invoke the API
resource "google_cloud_run_service_iam_policy" "api_gateway_speech_api_access" {

  location    = google_cloud_run_service.speech_api.location
  project     = google_cloud_run_service.speech_api.project
  service     = google_cloud_run_service.speech_api.name

  policy_data = data.google_iam_policy.sa_api_gateway_speech_access.policy_data
}

######################################
# API Gateway
######################################

# Components listed under this section could be moved to a separate module.

# [API Gateway] api
# Create main API gateway
resource "google_api_gateway_api" "main_api_gateway" {

  provider = google-beta
  api_id = "api-gateway"
  display_name = "Main API gateway"
}

# [API Gateway] config
# Create configuration for the gateway
resource "google_api_gateway_api_config" "main_api_cfg" {

  # NOTE: Update strategy is not entirely clear to me yet.
  # A possible solution could be to add a version postfix to the
  # OpenAPI file. Did not give this a try as the Terraform
  # component was optional.

  provider = google-beta
  api = google_api_gateway_api.main_api_gateway.api_id
  api_config_id = "speech-api-v1"

  openapi_documents {
    document {
      path = "../../services/api/speech-api.yaml"
      contents = filebase64("../../services/api/speech-api.yaml")
    }
  }

  gateway_config {
    backend_config {
      google_service_account = google_service_account.sa_api_gateway.email
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# [API Gateway] gateway
# Create gateway using the configuration defined in the previous step
resource "google_api_gateway_gateway" "main_api_gw" {
  provider = google-beta
  api_config = google_api_gateway_api_config.main_api_cfg.id
  gateway_id = "speech-api-v1"
}