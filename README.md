# Role Play - Web Application Engineer: Deploy

This repository owns resources to deploy a Scoring Server platform which is used in Role Play Competition.

# Prerequisites

## Create a project

Create a project for the Scoring Server platform

## Install Terraform and Modules

* Terraform: v1.3.0 or later
* hashicorp/google: v4.32.0 or later

## Update Organiziation policies

If your organization restricts your Google Cloud environment, update Organiziation policies like below:

| Policy | Should be |
| ------ | --------- |
| constraints/sql.restrictAuthorizedNetworks | Not enforced |
| constraints/iam.allowedPolicyMemberDomains | Allowed All |

## Enable required services

```
gcloud services enable run.googleapis.com sqladmin.googleapis.com iam.googleapis.com cloudtasks.googleapis.com cloudbuild.googleapis.com artifactregistry.googleapis.com secretmanager.googleapis.com container.googleapis.com spanner.googleapis.com
```

# Deploy

Set environment variables:

Replace the following variables with your environment information. `DATABASE_DATASTUDIO_PASSWORD` is the password you would like to set for database login by datastudio user.

```
export GOOGLE_CLOUD_PROJECT=<YOUR GOOGLE CLOUD PROJECT ID>
export DATABASE_DATASTUDIO_PASSWORD=<YOUR DATABASE PASSWORD FOR DATASTUDIO>
export DATASTUDIO_URL=<YOUR DATASTUDIO URL>
```

Execute Terraform scripts:

```
terraform init
terraform apply -var="project_id=${GOOGLE_CLOUD_PROJECT}" -var="database_datastudio_password=${DATABASE_DATASTUDIO_PASSWORD}" -var="data_studio_url=${DATASTUDIO_URL}" -var="portal_admin_api_key=${PORTAL_ADMIN_API_KEY}"
```

Once you deployed the resources, click on "RUN" of both `assess` and `portal` from Cloud Build Triggers.

# Test submission

Test if you can submit your request through the endpoint you get from Cloud Run.

# Troubleshooting

## Terraform

### Error 400: Repository mapping does not exist.

Visit to [Cloud Build](https://console.cloud.google.com/cloud-build/triggers/connect) to connect a repository to the project.
