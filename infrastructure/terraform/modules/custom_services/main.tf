# Enable API gateway
resource "google_project_service" "mainapigateway" {
  service                    = lookup(data.external.gateway_service_name.result, "serviceName")
  project                    = var.project
  disable_dependent_services = false
  disable_on_destroy         = false
}

# [External] data
# Some bash magic to automatically discover the API gateway services
# NOTE: Is highly coupled to the 'app-id' of the 'main_api_gateway' resources of the speech-api module
data "external" "gateway_service_name" {
  program = ["bash", "-c", "gcloud endpoints services list --project=${var.project} --filter='serviceName~api-gateway-.*.apigateway.${var.project}.cloud.goog' --format=json | jq '.[0]'"]
}