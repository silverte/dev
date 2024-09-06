# SQS Name
variable "sqs_app_name" {
  description = "SQS Name"
  type        = string
  default     = "app"
}

# Whether to create an SQS App (True or False)
variable "enable_sqs_app" {
  description = "Whether to create an SQS App"
  type        = bool
  default     = true
}
