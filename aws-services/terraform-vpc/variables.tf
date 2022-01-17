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

variable "vpc_cidr_block" {
  type = string
  #  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  #  default = "10.0.1.0/24"
  type = string
}

variable "incoming_cidr_blocks" {
  type = list(string)
}

variable "aws_subnet1_az" {
  type = string
  #  default = "us-east-2a"
}





