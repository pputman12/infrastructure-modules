variable "app_name" {
  type    = string
  default = "slack"
}

variable "okta_appname" {
  type    = string
  default = "slack"
}

variable "app_display_name" {
  type    = string
  default = "slack"
}

variable "accounts" {
  type = map(any)
}

variable "app_settings_json" {
  type    = map(any)
  default = {}
}

