#-------------------------------------------------------------------------------------------------------------------------------------
# HASHICORP VAULT VARIABLES 
# The vault server IP and Port, along with the path to our okta api token stored securely in vault

variable "vault_address" {
  description = "Hashicorp Vault Server Address"
  type        = string
}


variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "name" {
  default = "dynamic-aws-creds-vault-admin"
}
