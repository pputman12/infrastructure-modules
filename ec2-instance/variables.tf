
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
}

variable "ami_name_search" {
  type    = list(string)
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
  type    = string
  default = "t2.micro"
}

variable "vpc_id" {
  type = string
}

variable "instance_subnet_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "PUBLIC_KEY_PATH" {
  type = string
}
