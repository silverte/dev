# Whether to create an KMS EBS (True or False)
variable "create_kms_ebs" {
  description = "Whether to create an KMS EBS"
  type        = bool
  default     = false
}

# Management Account KMS Key ARN
variable "management_ebs_key_arn" {
  description = "Management Account KMS Key ARN"
  type        = string
  default     = ""
}
