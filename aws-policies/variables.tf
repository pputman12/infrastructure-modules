variable "aws_region" {
  type = string
}

variable "backend" {
  description = "Backend path to look for aws credentials"
  type        = string
  default     = "s3"
}

#variable "backend_path" {
#  description = "path in the backend to look for the tfstate"
#  type        = string
#  default     = "../vault-admin-workspace/terraform.tfstate"
#}

variable "ttl" {
  type    = string
  default = "1"
}



#-------------------------------------------------------------------------------------------------------------------------------------
# IAM POLICY LIST
# A list of objects, with a json encoded IAM Policy as the last parameter
#-------------------------------------------------------------------------------------------------------------------------------------

variable "policies" {
  type = list(object({
    description = string
    name        = string
    path        = string
    tags        = map(string)
    policy      = string
  }))
}
