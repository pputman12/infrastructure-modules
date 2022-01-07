
#-------------------------------------------------------------------------------------------------------------------------------------
# AWS REGION
#-------------------------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  type = string
}

variable "namespace" {
  type = string
}

variable "ami_owners" {
  type    = list(string)
  default = ["679593333241"]
}

variable "ami_name_search" {
  type    = list(string)
  default = ["hashicorp/marketplace/vault"]
}

variable "root_device_type" {
  type    = list(string)
  default = ["ebs"]
}

variable "virtualization_type" {
  type    = list(string)
  default = ["hvm"]
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "vpc_id" {
  type = string
}

variable "instance_subnet_id" {
  type = string
}

