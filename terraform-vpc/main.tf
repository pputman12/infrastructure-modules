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

provider "aws" {
  region = var.aws_region
}


resource "aws_vpc" "prod_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = "true" 
  enable_dns_hostnames = "true" 
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name = "prod-vpc"
  }
}

resource "aws_subnet" "prod_subnet_public_1" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.aws_subnet1_az
  tags = {
    Name = "prod-subnet-public-1"
  }
}

resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod_vpc.id
  tags = {
    Name = "prod-igw"
  }
}

resource "aws_route_table" "prod_public_crt" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_igw.id
  }

  tags = {
    Name = "prod-public-crt"
  }
}

resource "aws_route_table_association" "prod_crta_public_subnet_1" {
  subnet_id      = aws_subnet.prod_subnet_public_1.id
  route_table_id = aws_route_table.prod_public_crt.id
}

resource "aws_security_group" "ssh_allowed" {
  vpc_id = aws_vpc.prod_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.service_ports
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
    }
  }

    tags = {
    Name = "terraform-sg"
  }
}
