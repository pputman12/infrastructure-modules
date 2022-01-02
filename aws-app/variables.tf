#-------------------------------------------------------------------------------------------------------------------------------------
# HASHICORP VAULT VARIABLES 
# The vault server IP and Port, along with the path to our okta api token stored securely in vault
#-------------------------------------------------------------------------------------------------------------------------------------

variable "vault_address" {
  description = "Hashicorp Vault Server Address"
  type        = string
}

variable "vault_okta_secret_path" {
  description = "The path to access the okta credentials in Vault"
  type        = string
}


#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA CREDENTIAL VARIABLES 
# Variables for Okta credentials
#-------------------------------------------------------------------------------------------------------------------------------------

variable "okta_org_name" {
  description = "The okta account to connect to"
  type        = string
}

variable "okta_account_url" {
  description = "base okta url"
  type        = string
}

variable "okta_api_token" {
  type    = string
}


#-------------------------------------------------------------------------------------------------------------------------------------
# AWS REGION
#-------------------------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  type = string
}

#-------------------------------------------------------------------------------------------------------------------------------------
# ASSIGNMENTS TO THE AWS APP
# This lets you specify another name for the trusted identity provider in AWS if desired, fine to leave as default otherwise.
#-------------------------------------------------------------------------------------------------------------------------------------

# Name of the trusted identity provider in aws, can leave as default
variable "aws_saml_provider_name" {
  type    = string
  default = "Okta-SSO"
}

#-------------------------------------------------------------------------------------------------------------------------------------
# AWS FILTER FOR ORIGIN APPS 
# This refuses to let user accounts from other sources than aren't okta use this app to gain access to AWS.  Changing this will
# let you let users from another app, for instance Active Directory defined users, access AWS.  This is a security risk because if
# Someone who has admin privileges in AD, but not in Okta, creates an AD group named in a way that matches the role mapping regex,
# It will forward it through, granting them access to the specified role (and thus policy) in AWS.
#-------------------------------------------------------------------------------------------------------------------------------------

variable "aws_saml_app_filter" {
  type    = string
  default = "okta"
}

#-------------------------------------------------------------------------------------------------------------------------------------
# APP CONFIGURATION VARIABLES 
# Configuration variables for the saml application
#-------------------------------------------------------------------------------------------------------------------------------------


variable "app_name" {
  type    = string
  default = "aws"
}

variable "okta_appname" {
  type    = string
  default = "amazon_aws"
}

variable "app_display_name" {
  type    = string
  default = "AWS"
}

variable "accounts" {
  description = "Array of account names or domains for the app"
  type        = map(any)
}

variable "app_settings_json" {
  type    = map(any)
  default = {}
}

