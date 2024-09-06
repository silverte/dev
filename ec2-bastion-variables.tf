# EC2 Instance Type
variable "ec2_bastion_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t4g.medium"
}

# EC2 Root Volume size
variable "ec2_bastion_root_volume_size" {
  description = "EC2 Root Volume size"
  type        = number
  default     = 30
}

# EC2 EBS Volume size
variable "ec2_bastion_ebs_volume_size" {
  description = "EC2 EBS Volume size"
  type        = number
  default     = 30
}

# EC2 AMI Filter value
variable "ec2_bastion_ami_filter_value" {
  description = "EC2 AMI Filter value"
  type        = string
  default     = "al2023-ami-2023.5.20240805.0-kernel-6.1-arm64"
}

# Whether to create an EC2 Bastion (True or False)
variable "enable_ec2_bastion" {
  description = "Whether to create an EC2 Bastion"
  type        = bool
  default     = true
}