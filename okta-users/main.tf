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
# OKTA DYNAMIC USER CREATOR 
# Speciy user in variable in live module to create.
#-------------------------------------------------------------------------------------------------------------------------------------

resource "okta_user" "user" {
  for_each   = { for user in var.okta_users : user.login => user }
  first_name = each.value.first_name
  last_name  = each.value.last_name
  login      = each.value.login
  email      = each.value.email
  depends_on = [okta_user_schema_property.gcpRoles]
  custom_profile_attributes = try(jsonencode ( each.value.custom_profile_attributes), null)

  lifecycle {
    ignore_changes = [group_memberships, admin_roles]
  }
}


data "okta_user_type" "user" {
  name = "User"
}

resource "okta_user_schema_property" "gcpRoles" {
    array_type  = "string"
    description = "Google Cloud Profile Roles"
    index       = "gcpRoles"
    master      = "OKTA"
    permissions = "READ_ONLY"
    required    = false
    scope       = "NONE"
    title       = "GCP Roles"
    type        = "array"
    user_type   = "${data.okta_user_type.user.id}"
}

resource "okta_user_schema_property" "googleWorkspaceAdminRoles" {
    array_type  = "string"
    description = "Google Workspaces Roles"
    index       = "gwsRoles"
    master      = "OKTA"
    permissions = "READ_ONLY"
    required    = false
    scope       = "NONE"
    title       = "Google Workspace Roles"
    type        = "array"
    user_type   = "${data.okta_user_type.user.id}"
}


resource "okta_user_schema_property" "google" {
    description = "Google Workspace Domains"
    index       = "google"
    master      = "OKTA"
    permissions = "READ_ONLY"
    required    = false
    scope       = "NONE"
    title       = "Google Domain"
    type        = "array"
    user_type   = "${data.okta_user_type.user.id}"
    array_type  = "string"
}
