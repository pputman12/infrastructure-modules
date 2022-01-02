#-------------------------------------------------------------------------------------------------------------------------------------
# VERSION REQUIREMENTS 
# Versions of Teraform and its providers pinned for stability
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 1.1.0"
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20.2"
    }
  }
}

locals {
  groups_merged_with_app_id = [for group in var.group_assignments : merge(group, { for name, app in okta_app_saml.saml_app : "app_id" => app.id if name == group.account_name })]
  users_merged_with_app_id  = [for user in var.user_assignments : merge(user, { for name, app in okta_app_saml.saml_app : "app_id" => app.id if name == user.account_name })]
}

resource "okta_app_saml" "saml_app" {
  for_each            = var.app_configuration
  app_links_json      = try(jsonencode(each.value.app_links_json), "{}")
  app_settings_json   = jsonencode(each.value.app_settings_json != "" ? merge({ domain = each.key }, each.value.app_settings_json) : { domain = each.key })
  label               = "${each.value.app_display_name} ${each.key}"
  preconfigured_app   = var.okta_appname
  default_relay_state = try(each.value.default_relay_state, "")
  features            = []
  lifecycle {
    ignore_changes = [users, groups, app_settings_json, features]
  }
}


resource "okta_app_group_assignments" "group_assignments" {
  for_each   = { for group in local.groups_merged_with_app_id : group.name => group }
  app_id     = each.value.app_id
  depends_on = [okta_app_saml.saml_app]

  group {
    id = each.value.id
  }
}

resource "okta_app_user" "user_assignments" {
  for_each = { for assignment in local.users_merged_with_app_id : "${assignment.account_name}-${assignment.user}" => assignment }
  app_id   = each.value.app_id
  user_id  = each.value.user_id
  username = each.value.user
}

