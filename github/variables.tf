#-------------------------------------------------------------------------------------------------------------------------------------
# HASHICORP VAULT VARIABLES 
# The vault server IP and Port, along with the path to our okta api token stored securely in vault
#-------------------------------------------------------------------------------------------------------------------------------------

variable "vault_address" {
  description = "Hashicorp Vault Server Address"
  type        = string
}

variable "vault_github_secrets_path" {
  description = "The path to access the okta credentials in Vault"
  type        = string
}
variable "vault_aws_secrets_access_key_path" {
  description = "The path to access the aws credentials in Vault"
  type        = string
}
variable "vault_aws_secrets_access_key_path" {
  description = "The path to access the aws credentials in Vault"
  type        = string
}
variable "github_api_token" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_access_key" {
  type = string
}
