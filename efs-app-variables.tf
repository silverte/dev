# EFS Name
variable "efs_app_name" {
  description = "EFS Name"
  type        = string
  default     = "app"
}

# Whether to create an EFS App (True or False)
variable "create_efs_app" {
  description = "Whether to create an EFS App"
  type        = bool
  default     = false
}
