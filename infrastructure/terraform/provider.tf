terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 3.56.0"
    }
  }
}

provider "google-beta" {
  credentials =  file("account.json")
  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone

  credentials = file("account.json")
}