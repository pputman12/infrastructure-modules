
#-------------------------------------------------------------------------------------------------------------------------------------
# AWS REGION
#-------------------------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  type = string
}

variable "vault_address" {
  description = "Address to access credentials through vault"
  type        = string
}

variable "backend_bucket" {
  type = string
}

variable "backend_key" {
  type = string
}

variable "namespace" {
  type = string
}

variable "ami_id" {
  type = string
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

variable "PUBLIC_KEY_PATH" {
  type = string
}

variable "user_data" {
  type = string
}

variable "service_ports" {
  type = list(number)
}

variable "incoming_cidr_blocks" {
  type = list(string)
}

