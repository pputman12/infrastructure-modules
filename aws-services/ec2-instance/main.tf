#-------------------------------------------------------------------------------------------------------------------------------------
# VERSION REQUIREMENTS 
# Versions of Teraform and its providers pinned for stability
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 1.1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.1.1"
    }
  }
}

provider "vault" {
  address = var.vault_address
}

#-------------------------------------------------------------------------------------------------------------------------------------
# AWS PROVIDER MODULE
# Lets us use AWS resources
#-------------------------------------------------------------------------------------------------------------------------------------


data "terraform_remote_state" "admin" {
  backend = "s3"

  config = {
    bucket  = var.backend_bucket
    key     = var.backend_key
    region  = var.aws_region
    encrypt = true
  }
}

data "vault_aws_access_credentials" "creds" {
  backend = data.terraform_remote_state.admin.outputs.backend
  role    = data.terraform_remote_state.admin.outputs.role
}

provider "aws" {
  region     = var.aws_region
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
}



resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_groups]
  subnet_id              = var.instance_subnet_id
  user_data              = var.user_data
  tags = {
    Name = "${var.namespace}-instance"
  }
  key_name = aws_key_pair.ssh-key-pair.id
}

resource "aws_eip" "ec2_instance_ip" {
  instance = aws_instance.ec2_instance.id
}

resource "aws_key_pair" "ssh-key-pair" {
  key_name   = "${var.namespace}-key-pair"
  public_key = file(var.PUBLIC_KEY_PATH)
}
