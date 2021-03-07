# NOTE: Services are best defined in a separate Terraform scope
# or project. This may lead to failures in initial Terraform applies.
# Did this quickly to demonstrate Terraform deployment of the API.

# Enable IAM
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

# Enable the main api gateway service, as to grant key usage
# Note: This is a bit of a strange one, this service is created by Terraform
# but there it appears that there is no way to extract the service name
# from the TF resource.
resource "google_project_service" "mainapigateway" {
  service                    = "api-gateway-1e5s0b4vapgc3.apigateway.geometric-ocean-284614.cloud.goog"
  project                    = var.project
  disable_dependent_services = false
  disable_on_destroy         = false
}

