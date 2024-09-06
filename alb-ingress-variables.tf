# Whether to create an ALB ingress (True or False)
variable "enable_alb" {
  description = "Whether to create an ALB"
  type        = bool
  default     = true
}
