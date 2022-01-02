
variable "app_name" {
  type    = string
  default = "google"
}

variable "okta_appname" {
  type    = string
  default = "google"
}

variable "app_display_name" {
  type    = string
  default = "google"
}

variable "accounts" {
  type = map(any)
}

variable "app_settings_json" {
  type    = map(any)
  default = {}
}

