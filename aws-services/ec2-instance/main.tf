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
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------
# AWS PROVIDER MODULE
# Lets us use AWS resources
#-------------------------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}



resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_groups]
  subnet_id              = var.instance_subnet_id
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
