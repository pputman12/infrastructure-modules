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
# DATA FOR OKTA_GROUPS/SLACK SPACES
# Pulls out the okta groups specified for google and filters the account names by workspsaces variable.  This is because the google
# provider has no api to redeploy the saml integration, so if all google groups are removed from okta, and we dynamically create
# the aplication based on existing groups, it will delete any app without an assigned group, and then to redeploy requires us to
# go back into the google api and recreate the saml integrtion.  We can dynamically create the assignemtns to it.
#-------------------------------------------------------------------------------------------------------------------------------------


data "okta_groups" "okta_groups" {}


locals {
  app_groups            = [for group in data.okta_groups.okta_groups.groups : merge(group, { "role" = element(split("-", group.name), 3), "account_name" = element(split("-", group.name), 2) }) if(var.app_name == element(split("-", group.name), 1))]
  app_group_assignments = [for group in local.app_groups : group if contains(keys(var.accounts), group.account_name)]


  app_configuration = { for name, account in var.accounts : name => merge(account, { "app_display_name" = var.app_display_name, app_settings_json = var.app_settings_json }) }
}

#  app_users    = { for user in data.okta_users.gcpUsers.users : user.login =>  merge({"id" = user.id},  jsondecode(user.custom_profile_attributes)) }
#  app_user_assignments = flatten([ for username, user  in local.app_users : distinct([ for role in user.gcpRoles: { "user" = username , "account_name" = element(split("|", role), 1), "user_id" = user.id } ])])
#}
#




module "saml-app" {
  source            = "../saml-app/"
  accounts          = var.accounts
  okta_appname      = var.okta_appname
  app_configuration = local.app_configuration
  #  user_assignments = local.app_user_assignments
  group_assignments = local.app_group_assignments
}

