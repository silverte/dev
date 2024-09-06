# S3 Bucket Name
variable "s3_bucket_app_name" {
  description = "S3 Bucket Name"
  type        = string
  default     = "app"
}

# Whether to create an S3 Bucket App (True or False)
variable "enable_s3_bucket_app" {
  description = "Whether to create an S3 Bucket App"
  type        = bool
  default     = true
}
