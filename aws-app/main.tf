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
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
    }
  }
}

data "okta_groups" "okta_groups" {}

locals {
  app_groups            = [for group in data.okta_groups.okta_groups.groups : merge(group, { "role" = element(split("-", group.name), 3), "account_name" = element(split("-", group.name), 2) }) if(var.app_name == element(split("-", group.name), 1))]
  app_group_assignments = [for group in local.app_groups : group if contains(keys(var.accounts), group.account_name)]
  app_configuration     = { for name, account in var.accounts : name => merge(account, { "app_display_name" = var.app_display_name, app_settings_json = local.app_settings_json }) }


  #  app_users    = { for user in data.okta_users.gcpUsers.users : user.login =>  merge({"id" = user.id},  jsondecode(user.custom_profile_attributes)) }
  #  app_user_assignments = flatten([ for username, user  in local.app_users : distinct([ for role in user.gcpRoles: { "user" = username , "account_name" = element(split("|", role), 1), "user_id" = user.id } ])])




  app_settings_json = {
    # AppFilter set by variable in variables.tf to restrict source of users
    "appFilter" : "${var.aws_saml_app_filter}",
    "awsEnvironmentType" : "aws.amazon",
    # Regex responsponsible for detecting group is meant to go to aws, with account ID, and mapped to the proper role
    "groupFilter" : "^app\\-aws\\-(?{{accountid}}\\d+)\\-(?{{role}}[\\w\\-]+)$"
    "joinAllRoles" : true,
    "loginURL" : "https://console.aws.amazon.com/ec2/home",
    "roleValuePattern" : "arn:aws:iam::$${accountid}:saml-provider/${var.aws_saml_provider_name},arn:aws:iam::$${accountid}:role/$${role}",
    "sessionDuration" : 3600,
    # Use Group Mapping will make the above regex work, so groups are automatically assigned to Role at specified account
    "useGroupMapping" : true,
    "identityProviderArn" : "aws_iam_saml_provider.${var.aws_saml_provider_name}.arn",
  }

}

resource "aws_iam_saml_provider" "saml_provider" {
  for_each               = module.saml-app.saml-app
  name                   = var.aws_saml_provider_name
  saml_metadata_document = each.value.metadata
  tags = {
    "Name" = "okta sso saml provider"
  }
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithSAML"]

    principals {
      type        = "Federated"
      identifiers = [for provider in aws_iam_saml_provider.saml_provider : provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "SAML:aud"

      values = [
        "https://signin.aws.amazon.com/saml"
      ]
    }
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------
# ROLE CREATION
# The automatic group to role matching is great, but wanted a way to also generate the role and mape it to a  policy so this wouldn't
# have to be managed in AWS. The Group mapping maps User to Role, but with this, we'll automatically generate the role name as well
# The Role will have the same name as the Policy it maps to.  If no policy exists, it will fail, you can use either an AWS Managed
# Policy, or a custom one (can specify the custom policy in aws-policies terraform module)
#-------------------------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy" "valid_policies" {
  for_each = { for group in local.app_groups : group.name => group }
  name     = each.value.role
}


resource "aws_iam_role" "okta-role" {
  for_each            = { for policy in data.aws_iam_policy.valid_policies : policy.name => policy }
  name                = each.value.name
  assume_role_policy  = data.aws_iam_policy_document.instance-assume-role-policy.json
  managed_policy_arns = [each.value.arn]
  tags = {
    "Name" = each.value.name
  }
}

module "saml-app" {
  source            = "../saml-app/"
  accounts          = var.accounts
  okta_appname      = var.okta_appname
  app_configuration = local.app_configuration
  #  user_assignments = local.app_user_assignments
  group_assignments = local.app_group_assignments
}
