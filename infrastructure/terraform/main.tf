module "speech-api" {
  source = "./modules/services/speech-api"

  project           = var.project
  env               = var.env
  region            = var.region
  zone              = var.zone
}