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
# OKTA RULE TO GROUP CREATION/MAPPING 
# This lets you create a new group dynamically by specifying OKTA's extremely granular rules.  The First resource will make a group
# with a name starting with app-${appname}  and then will automatically use the rbac expression language to map to the created rule.
# This allows for more security than just manually assigning people to their organization's internal teams and granting blanket
# access to resources based on that team.  Using Okta's extremely granular expression language allows you to be as specific as possible
# when specifying permissions
#-------------------------------------------------------------------------------------------------------------------------------------

resource "okta_group" "app" {
  for_each    = var.apps
  name        = "app-${each.key}"
  description = "Do Not Edit, RBAC"
  #Do not add users here, use rules only
}

resource "okta_group_rule" "app" {
  for_each          = var.apps
  name              = "rbac-app-${each.key}"
  status            = "ACTIVE"
  group_assignments = [okta_group.app[each.key].id]
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = each.value.rule
  users_excluded    = []
}
