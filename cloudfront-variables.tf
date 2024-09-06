# Whether to create an CloudFront ingress (True or False)
variable "enable_cloudfront" {
  description = "Whether to create an CloudFront"
  type        = bool
  default     = true
}
