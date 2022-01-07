variable "aws_region" {
  type = string
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.0.1.0/24"
  type    = string
}

variable "incoming_cidr_blocks_ssh" {
  type    = list(string)
#  default = ["68.190.0.0/16"]
}

variable "aws_subnet1_az" {
  type = string
#  default = "us-east-2a"
}

variable "service_ports" {
 type = list(number)
 default = [22, 8200]
}
