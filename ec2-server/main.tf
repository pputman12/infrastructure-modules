#-------------------------------------------------------------------------------------------------------------------------------------
# VERSION REQUIREMENTS 
# Versions of Teraform and its providers pinned for stability
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 1.1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
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


data "aws_ami" "ami" {
  executable_users = ["self"]
  most_recent      = true
  owners           = var.ami_owners

  filter {
    name   = "name"
    values = var.ami_name_search
  }

  filter {
    name   = "root-device-type"
    values = var.root_device_type
  }

  filter {
    name   = "virtualization-type"
    values = var.virtialization_type
  }
}

resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.aws_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_instance_sg.id]
  subnet_id              = var.instance_subnet_id
  tags = {
    Name = "${var.namespace}-instance"
  }
}

resource "aws_eip" "ec2_instance_ip" {
  instance = aws_instance.ec2_instance.id
}

resource "aws_security_group" "ec2_instance_sg" {
  name        = "${var.namespace}-sg"
  description = "${var.namespace} security group for Port ${var.port}"
  vpc_id       = var.vpc_id

  ingress {
    for_each 
    description = "Port ${port.name"
    from_port   = var.port
    to_port     = var.port
    protocol    = var.port_protocol
    cidr_blocks = var.inbound_cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

output "ec2_instance_ip" {
  value = aws_eip.ec2_instance_ip.public_ip
}
