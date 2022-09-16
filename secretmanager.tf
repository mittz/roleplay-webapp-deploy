resource "google_secret_manager_secret" "portal_admin_api_key" {
  secret_id = "portal-admin-api-key"

  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "portal_admin_api_key_version" {
  secret = google_secret_manager_secret.portal_admin_api_key.id
  secret_data = var.portal_admin_api_key
}

resource "google_secret_manager_secret_iam_member" "member" {
  project = google_secret_manager_secret.portal_admin_api_key.project
  secret_id = google_secret_manager_secret.portal_admin_api_key.secret_id
  role = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${module.service_account_portal.service_account.email}"
}