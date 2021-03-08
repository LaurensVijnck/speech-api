# Enable the main api gateway service, as to grant key usage
# Source: https://cloud.google.com/api-gateway/docs/quickstart-console#securing_access_by_using_an_api_key
#
# Note: This is a bit of a strange one, this service is created by Terraform
# but there it appears that there is no way to extract the service name
# from the TF resource.
#
# NOTE: Temp. disable this service if Terraform stalls. A possible solution
# could be to create separate service/scope and deploy.
resource "google_project_service" "mainapigateway" {
  service                    = "api-gateway-1e5s0b4vapgc3.apigateway.geometric-ocean-284614.cloud.goog"
  project                    = var.project
  disable_dependent_services = false
  disable_on_destroy         = false
}

