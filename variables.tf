variable "project_id" {
    description = "Project ID"
    type        = string
}

variable "region" {
    description = "Region"
    type        = string
    default     = "us-central1"
}

variable "zone" {
    description = "Zone"
    type        = string
    default     = "us-central1-c"
}

variable "database_datastudio_password" {
    description = "Password of database user for Data Studio"
    type = string
}

variable "cloudsql_postgresql_score_authorized_networks" {
    default = [{
        name  = "datastudio-source-1"
        value = "142.251.74.0/23"
    }, {
        name  = "datastudio-source-2"
        value = "74.125.0.0/16"
    }]
    type        = list(map(string))
    description = "List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs"
}

variable "data_studio_url" {
    description = "URL of Data Studio for ranking dashboard"
    type        = string
}

variable "portal_source_github_owner" {
    description = "GitHub owner of portal source repository"
    type        = string
}

variable "portal_source_github_repository_name" {
    description = "GitHub repository name of portal"
    type        = string
}

variable "assess_source_github_owner" {
    description = "GitHub owner of assess source repository"
    type        = string
}

variable "assess_source_github_repository_name" {
    description = "GitHub repository name of assess"
    type        = string
}

variable "artifact_registry_repository_name" {
    description = "Artifact Registry repository name"
    type        = string
}

variable "portal_admin_api_key" {
    description = "Admin API key used by Portal"
    type        = string
}