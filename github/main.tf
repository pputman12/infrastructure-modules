#-------------------------------------------------------------------------------------------------------------------------------------
# VERSION REQUIREMENTS 
# Versions of Teraform and its providers pinned for stability
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 1.1.0" 
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
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

data "vault_generic_secret" "github_creds" {
  path = var.vault_github_secrets_path
}

data "vault_generic_secret" "aws_access_key" {
  path = var.vault_aws_secrets_access_key_path
}


data "vault_generic_secret" "aws_secret_key" {
  path = var.vault_aws_secrets_secret_key_path
}


provider "github" {
  token = data.vault_generic_secret.github_creds.data[var.github_api_token]

}


resource "github_repository" "terraform-repo" {
  name          = var.github_repo
  description   = "Continuous Integration with GitHub Actions and HashiCorp Terraform"
  visibility    = "public"
  has_projects  = false
  has_wiki      = false
  has_downloads = false
  license_template = "mit"
  topics = ["example", "public", "ci", "continuous-integration", "terraform", "github", "github-actions"]
}

resource "github_actions_secret" "terraform-repo-aws-access-key" {
  repository       = "github-action-terraform"
  secret_name      = "AWS_ACCESS_KEY_ID"
  plaintext_value  = data.vault_generic_secret.aws_access_key.data[var.aws_access_key]
  depends_on       = [github_repository.terraform-repo]
}

resource "github_actions_secret" "terraform-repo-secret-key" {
  repository       = "github-action-terraform"
  secret_name      = "AWS_SECRET_ACCESS_KEY"
  plaintext_value  = data.vault_generic_secret.aws_secret_key.data[var.aws_secret_key]
  depends_on       = [github_repository.terraform-repo]

}
