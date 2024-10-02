# Whether to create an IAM assumeable role (True or False)
variable "create_iam_assumeable_role" {
  description = "Whether to create an IAM assumeable role"
  type        = bool
  default     = true
}

# Management Account ID
variable "iam_management_account_id" {
  description = "Management Account ID"
  type        = string
  default     = "928933996765"
}