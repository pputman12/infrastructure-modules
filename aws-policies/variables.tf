#-------------------------------------------------------------------------------------------------------------------------------------
# IAM POLICY LIST
# A list of objects, with a json encoded IAM Policy as the last parameter
#-------------------------------------------------------------------------------------------------------------------------------------

variable "policies" {
  type    = list(object({
    description = string
    name        = string
    path        = string
    tags        = map(string)
    policy      = string
  }))
}

variable "aws_region" {
  type = string
}
