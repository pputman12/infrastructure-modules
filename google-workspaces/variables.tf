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
# OKTA API CREDENTIALS
# Credentials for the okta api
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

variable "google_customer_id" {
  type = string
}

variable "impersonated_user_email" {
  type = string
}

variable "credentials" {
  type = string
}
variable "oauth_scopes" {
  type = string
}







#-------------------------------------------------------------------------------------------------------------------------------------
# APPLICATION CONFIGURATION
# Configuration for the saml application
#-------------------------------------------------------------------------------------------------------------------------------------


variable "app_name" {
  type    = string
  default = "google"
}

variable "okta_appname" {
  type    = string
  default = "google"
}

variable "app_display_name" {
  type    = string
  default = "google"
}

variable "google_workspaces_accounts" {
  type = map(any)
}

variable "app_settings_json" {
  type    = map(any)
  default = {}
}
