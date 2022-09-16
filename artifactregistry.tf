resource "google_artifact_registry_repository" "roleplay_webapp" {
  location      = var.region
  repository_id = var.artifact_registry_repository_name
  format        = "DOCKER"
}