module "service_account_portal" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = var.project_id
  names         = ["portal"]
  project_roles = [
    "${var.project_id}=>roles/cloudtasks.enqueuer",
    "${var.project_id}=>roles/cloudtasks.taskRunner",
    "${var.project_id}=>roles/cloudtasks.viewer",
    "${var.project_id}=>roles/cloudsql.instanceUser",
    "${var.project_id}=>roles/cloudsql.client",
    "${var.project_id}=>roles/run.developer",
    "${var.project_id}=>roles/iam.serviceAccountUser",
  ]
}

module "service_account_benchmark" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = var.project_id
  names         = ["benchmark"]
  project_roles = [
    "${var.project_id}=>roles/run.developer",
    "${var.project_id}=>roles/cloudsql.instanceUser",
    "${var.project_id}=>roles/cloudsql.client",
  ]
}

module "service_account_cloudbuild" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = var.project_id
  names         = ["cloudbuild"]
  project_roles = [
    "${var.project_id}=>roles/run.admin",
    "${var.project_id}=>roles/iam.serviceAccountUser",
    "${var.project_id}=>roles/logging.logWriter",
    "${var.project_id}=>roles/artifactregistry.writer",
    "${var.project_id}=>roles/storage.admin",
  ]
}