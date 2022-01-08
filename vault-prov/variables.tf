#-------------------------------------------------------------------------------------------------------------------------------------
# HASHICORP VAULT VARIABLES 
# The vault server IP and Port, along with the path to our okta api token stored securely in vault

variable "vault_address" {
  description = "Hashicorp Vault Server Address"
  type        = string
}


variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "name" { default = "dynamic-aws-creds-vault-admin" }
