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
  type = string
}


#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA USER 
# List of maps to create thes specified users
#-------------------------------------------------------------------------------------------------------------------------------------

variable "okta_users" {
  type = any
}
