# Whether to create an ECR App (True or False)
variable "enable_ecr_app" {
  description = "Whether to create an ECR App"
  type        = bool
  default     = false
}

# ECR Name
variable "ecr_app_name" {
  description = "ECR Name"
  type        = string
  default     = "app"
}
