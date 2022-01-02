#-------------------------------------------------------------------------------------------------------------------------------------
# GOOGLE PROVIDER CREDENTIALS
# Configuration for the google cloud
#-------------------------------------------------------------------------------------------------------------------------------------

variable "google_terraform_project" {
  description = "Google project for terraform"
  type        = string
}

variable "google_region" {
  type        = string
}

variable "google_zone" {
  type        = string
}





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



