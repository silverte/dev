# Whether to create an ALB ingress (True or False)
variable "create_alb" {
  description = "Whether to create an ALB"
  type        = bool
  default     = false
}
