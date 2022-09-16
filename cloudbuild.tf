locals {
    portal_service_name = "portal"
    assess_service_name = "assess"
}

resource "google_cloudbuild_trigger" "portal_trigger" {
  name            = "portal"
  service_account = module.service_account_cloudbuild.service_account.id

  build {
    substitutions = {
      "_CLOUDRUN_MIN_INSTANCES"            = "0"
      "_CLOUDRUN_MAX_INSTANCES"            = "2"
      "_CLOUDRUN_INSTANCE_CONNECTION_NAME" = "${google_sql_database_instance.score.connection_name}"
    }

    step {
      args = [
        "build",
        "-t",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_name}/${local.portal_service_name}-runtime",
        "-f",
        "run.Dockerfile",
        ".",
      ]
      id         = "BuildPortalRuntimeImage"
      name       = "gcr.io/cloud-builders/docker"
    }

    step {
      args = [
        "push",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_name}/${local.portal_service_name}-runtime",
      ]
      id   = "PushPortalRuntimeImage"
      name = "gcr.io/cloud-builders/docker"
    }

    step {
      args = [
        "build",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_name}/${local.portal_service_name}",
        "--builder=gcr.io/buildpacks/builder:v1",
        "--run-image=${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_name}/${local.portal_service_name}-runtime"
      ]
      entrypoint = "pack"
      id         = "BuildPortalImage"
      name       = "gcr.io/k8s-skaffold/pack"
    }

    step {
      args = [
        "push",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_name}/${local.portal_service_name}",
      ]
      id   = "PushPortalImage"
      name = "gcr.io/cloud-builders/docker"
    }

    step {
      args = [
        "run",
        "deploy",
        "${local.portal_service_name}",
        "--allow-unauthenticated",
        "--platform=managed",
        "--region=${var.region}",
        "--image=${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_name}/${local.portal_service_name}",
        "--min-instances=$_CLOUDRUN_MIN_INSTANCES",
        "--max-instances=$_CLOUDRUN_MAX_INSTANCES",
        "--add-cloudsql-instances=${google_sql_database_instance.score.connection_name}",
        "--service-account=${module.service_account_portal.email}",
        "--set-env-vars=DATA_STUDIO_URL=${var.data_studio_url}",
        "--set-env-vars=INSTANCE_CONNECTION_NAME=${google_sql_database_instance.score.connection_name}",
        "--set-env-vars=DATABASE_NAME=${google_sql_database.score.name}",
        "--set-env-vars=DATABASE_USER=${module.service_account_portal.service_account.account_id}@${var.project_id}.iam",
        "--set-env-vars=QUEUE_NAME=${google_cloud_tasks_queue.queue.name}",
        "--set-env-vars=PROJECT_ID=${var.project_id}",
        "--quiet",
      ]
      entrypoint = "gcloud"
      id         = "Deploy"
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk:slim"
    }

    logs_bucket = "${google_storage_bucket.cloudbuild.url}/${local.portal_service_name}/logs"
  }
  github {
    owner = var.portal_source_github_owner
    name  = var.portal_source_github_repository_name
    push {
      branch = "^main$"
    }
  }
}

resource "google_cloudbuild_trigger" "assess_trigger" {
  name            = local.assess_service_name
  service_account = module.service_account_cloudbuild.service_account.id

  build {
    step {
      args = [
        "build",
        "-t",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_name}/${local.assess_service_name}-runtime",
        "-f",
        "run.Dockerfile",
        ".",
      ]
      id         = "BuildAssessRuntimeImage"
      name       = "gcr.io/cloud-builders/docker"
    }

    step {
      args = [
        "push",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_name}/${local.assess_service_name}-runtime",
      ]
      id   = "PushAssessRuntimeImage"
      name = "gcr.io/cloud-builders/docker"
    }

    step {
      args = [
        "build",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_name}/${local.assess_service_name}",
        "--builder=gcr.io/buildpacks/builder:v1",
        "--run-image=${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_name}/${local.assess_service_name}-runtime"
      ]
      entrypoint = "pack"
      id         = "Buildpack"
      name       = "gcr.io/k8s-skaffold/pack"
    }

    step {
      args = [
        "push",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository_name}/${local.assess_service_name}",
      ]
      id   = "Push"
      name = "gcr.io/cloud-builders/docker"
    }

    logs_bucket = "${google_storage_bucket.cloudbuild.url}/${local.assess_service_name}/logs"
  }
  github {
    owner = var.assess_source_github_owner
    name  = var.assess_source_github_repository_name
    push {
      branch = "^main$"
    }
  }
}
