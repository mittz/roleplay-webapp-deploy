resource "random_id" "db_instance_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "score" {
  name             = "score-${random_id.db_instance_name_suffix.hex}"
  database_version = "POSTGRES_12"

  settings {
    tier              = "db-custom-2-6144"
    availability_type = "REGIONAL"

    ip_configuration {
      ipv4_enabled        = true
      private_network     = null
      require_ssl         = false
      allocated_ip_range  = null
      dynamic "authorized_networks" {
        for_each = var.cloudsql_postgresql_score_authorized_networks
        iterator = network

        content {
          name  = network.value.name
          value = network.value.value
        }
      }
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
  }
}

resource "google_sql_database" "score" {
  name     = "score"
  instance = google_sql_database_instance.score.name
}

resource "google_sql_user" "datastudio" {
  name     = "datastudio"
  password = var.database_datastudio_password
  instance = google_sql_database_instance.score.name
}

resource "google_sql_user" "portal" {
  name     = "${module.service_account_portal.service_account.account_id}@${var.project_id}.iam"
  instance = google_sql_database_instance.score.name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
}

resource "google_sql_user" "benchmark" {
  name     = "${module.service_account_benchmark.service_account.account_id}@${var.project_id}.iam"
  instance = google_sql_database_instance.score.name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
}