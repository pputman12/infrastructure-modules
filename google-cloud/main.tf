#-------------------------------------------------------------------------------------------------------------------------------------
# VERSION REQUIREMENTS 
# Versions of Teraform and its providers pinned for stability
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 1.1.0"
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.5.0"
    }
  }
}


#-------------------------------------------------------------------------------------------------------------------------------------
# VAULT VARIABLES 
# Refers to variables for Hashicorp Vault in variables.tf
#-------------------------------------------------------------------------------------------------------------------------------------

provider "vault" {
  address = var.vault_address
}

data "vault_generic_secret" "okta_creds" {
  path = var.vault_okta_secret_path
}

data "vault_generic_secret" "google_credentials"{
  path = var.vault_google_credentials_path
}

#-------------------------------------------------------------------------------------------------------------------------------------
# GOOGLE CREDENTIALS
# Google api token file
#-------------------------------------------------------------------------------------------------------------------------------------



provider "google" {
  project     = var.google_terraform_project
  region      = var.google_region
  zone        = var.google_zone
  credentials = data.vault_generic_secret.google_credentials.data[var.google_credentials]
}


#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA CREDENTIALS
# allows login to okta, api_token pointing here to data source created for hashicorp vault secure secret storage
#-------------------------------------------------------------------------------------------------------------------------------------

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_account_url
  api_token = data.vault_generic_secret.okta_creds.data[var.okta_api_token]
}


#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA ATTRIBUTE SEARCH
# Data source searches for the GcpRoles attribute and pulls users out
#-------------------------------------------------------------------------------------------------------------------------------------

data "okta_users" "gcpUsers" {
  search {
    name       = try("profile.gcpRoles")
    value      = try("roles")
    comparison = try("sw")
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------
# DATA FOR ASSIGNMENTS TO APP AND GCP ROLES
# Local variables set the group app assignments (RBAC), the user app assignments (ABAC), the mapped users (role permissions in GCP)
# and the app configuration (per app/domain settings)
#-------------------------------------------------------------------------------------------------------------------------------------

locals {

  cloud_app_configuration = { for name, account in var.accounts : name => merge(account, { "app_display_name" = var.app_display_name, app_settings_json = var.app_settings_json }) }

  cloud_app_users            = flatten([for user in data.okta_users.gcpUsers.users : merge(user, jsondecode(user.custom_profile_attributes))])
  cloud_app_user_assignments = flatten([for user in local.cloud_app_users : distinct([for role in user.gcpRoles : { "user" = user.email, "account_name" = element(split("|", role), 1), "user_id" = user.id }])])

  cloud_role_assignments     = flatten([for user in local.cloud_app_users : [for role in user.gcpRoles : { "project" = element(split("|", role), 2), "account" = element(split("|", role), 1), "role" = element(split("|", role), 0), "user" = "user:${user.email}" } if contains(keys(var.accounts), element(split("|", role), 1))]])
}


#-------------------------------------------------------------------------------------------------------------------------------------
# GOOGLE CLOUD ROLE ASSIGNMENTS
# Maps Users with the GCP role setting in profile in okta to the proper roles/domain/project in google cloud
#-------------------------------------------------------------------------------------------------------------------------------------

resource "google_project_iam_member" "rolemapping" {
  for_each = { for assignment in local.cloud_role_assignments : "${assignment.user}-${assignment.account}-${assignment.role}-${assignment.project}" => assignment }
  member   = each.value.user
  role     = each.value.role
  project  = each.value.project
}


#-------------------------------------------------------------------------------------------------------------------------------------
# SAML APP MODULE
# Passes the app and assignment data to the saml app module for creation/assignment
#-------------------------------------------------------------------------------------------------------------------------------------

module "saml-app" {
  source            = "../saml-app/"
  accounts          = var.accounts
  okta_appname      = var.okta_appname
  app_configuration = local.cloud_app_configuration
  user_assignments  = local.cloud_app_user_assignments
}
