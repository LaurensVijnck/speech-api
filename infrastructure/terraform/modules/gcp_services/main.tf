# Enable IAM
resource "google_project_service" "project" {
  service                    = "iam.googleapis.com"
  project                    = var.project
  disable_dependent_services = false
  disable_on_destroy         = false
}

# Enable IAM credentials
resource "google_project_service" "iam_service_account_credentials" {
  service                    = "iamcredentials.googleapis.com"
  project                    = var.project
  disable_dependent_services = false
  disable_on_destroy         = false
}

# Enable cloud speech API
resource "google_project_service" "speech" {
  service                    = "speech.googleapis.com"
  project                    = var.project
  disable_dependent_services = false
  disable_on_destroy         = false
}

# Enable cloud run API
resource "google_project_service" "cloudrun" {
  service                    = "run.googleapis.com"
  project                    = var.project
  disable_dependent_services = false
  disable_on_destroy         = false
}

# Enable Service Management
resource "google_project_service" "servicemanagement" {
  service                    = "servicemanagement.googleapis.com"
  project                    = var.project
  disable_dependent_services = false
  disable_on_destroy         = false
}

# Enable Service Control
resource "google_project_service" "servicecontrol" {
  service                    = "servicecontrol.googleapis.com"
  project                    = var.project
  disable_dependent_services = false
  disable_on_destroy         = false
}

# Enable API gateway
resource "google_project_service" "apigateway" {
  service                    = "apigateway.googleapis.com"
  project                    = var.project
  disable_dependent_services = false
  disable_on_destroy         = false
}

# Enable resource manager
resource "google_project_service" "gcp_resource_manager_api" {
  service = "cloudresourcemanager.googleapis.com"
  project                    = var.project
  disable_dependent_services = false
  disable_on_destroy         = false
}