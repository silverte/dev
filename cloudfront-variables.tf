# Whether to create an CloudFront ingress (True or False)
variable "create_cloudfront" {
  description = "Whether to create an CloudFront"
  type        = bool
  default     = false
}