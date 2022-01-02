variable "accounts" {
  type = map(any)
}

variable "okta_appname" {
  type = string
}

variable "user_assignments" {
  type = list(map(string))
  default = []
}

variable "group_assignments" {
  type = list(map(string))
  default = []
}

variable "app_configuration" {
  type = map(any) 
}
