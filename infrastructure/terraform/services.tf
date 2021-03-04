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
