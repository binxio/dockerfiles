provider "google" {
  project = "binxio-dockerfiles"
}

terraform {
  backend "gcs" {
    bucket = "binxio-dockerfiles-tf-state"
    prefix = "terraform/state"
  }
}

locals {
  gcp_service_apis = [
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
  ]
}

resource "google_project_service" "default" {
  count   = length(local.gcp_service_apis)
  service = local.gcp_service_apis[count.index]
}

resource "google_storage_bucket" "default" {
  name          = "binxio-dockerfiles-tf-state"
  location      = "EU"
  force_destroy = true
  versioning {
    enabled = true
  }
}

resource "google_cloudbuild_trigger" "github_binxio_dockerfiles_trigger" {
  name     = "github-binxio-dockerfiles-trigger"
  filename = "cloudbuild.yaml"

  github {
    owner = "binxio"
    name  = "dockerfiles"
    push {
      branch = "main"
    }
  }

  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"

  depends_on = [
    google_project_service.default
  ]
}

resource "google_artifact_registry_repository" "docker" {
  location      = "europe-west4"
  repository_id = "docker"
  description   = "Binx.io Docker Repository"
  format        = "DOCKER"

  depends_on = [
    google_project_service.default
  ]
}
