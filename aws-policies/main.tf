#-------------------------------------------------------------------------------------------------------------------------------------
# VERSION REQUIREMENTS 
# Versions of Teraform and its providers pinned for stability
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 1.1.0" 
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider aws {
  region = var.aws_region
}
  

#-------------------------------------------------------------------------------------------------------------------------------------
# IAM POLICY GENERATOR 
# This Resource will generate policies from a list of objects, defined in variables file
#-------------------------------------------------------------------------------------------------------------------------------------

resource "aws_iam_policy" "policy" {
  for_each = { for policy in var.policies : policy.name => policy }

  name        = each.value.name
  path        = each.value.path != "" ? each.value.path :null
  description = each.value.description != "" ? each.value.description : null
  policy      = each.value.policy
  tags	      = length(each.value.tags) > 0 ? each.value.tags : {}
}
