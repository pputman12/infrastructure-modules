variable "app_name" {
  type    = string
  default = "cloudconsole"
}

variable "okta_appname" {
  type    = string
  default = "cloudconsole"
}

variable "app_display_name" {
  type    = string
  default = "Google Cloud"
}

variable "accounts" {
  type = map(any)
}

variable "app_settings_json" {
  type    = map(any)
  default = {}
}

#variable "cloud-roles" {
#  type = string
#}
