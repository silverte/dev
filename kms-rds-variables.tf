# Whether to create an KMS RDS (True or False)
variable "enable_kms_rds" {
  description = "Whether to create an KMS RDS"
  type        = bool
  default     = false
}

# Management Account KMS Key ARN
variable "management_rds_key_arn" {
  description = "Management Account KMS Key ARN"
  type        = string
  default     = ""
}
