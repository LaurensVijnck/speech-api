module "gcp_services" {
  source = "./modules/gcp_services"

  project = var.project
}

module "speech-api" {
  source = "./modules/speech-api"

  project           = var.project
  env               = var.env
  region            = var.region
  zone              = var.zone
}

module "custom_services" {
  source = "./modules/custom_services"

  project = var.project
}