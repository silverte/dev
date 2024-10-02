# VPC CIDR Block
variable "cidr_dev" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

# VPC Public Subnets
variable "public_subnets_dev" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = [""]
}

# VPC Private Subnets
variable "private_subnets_dev" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = [""]
}

# VPC Infra Subnets
variable "endpoint_subnets_dev" {
  description = "A list of infra subnets inside the VPC"
  type        = list(string)
  default     = [""]
}

# VPC Database Subnets
variable "database_subnets_dev" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = [""]
}

# VPC ELB Subnets
variable "elb_subnets_dev" {
  description = "A list of ELB subnets inside the VPC"
  type        = list(string)
  default     = [""]
}

# VPC TGW Attachment Subnets
variable "tgw_attach_subnets_dev" {
  description = "A list of TGW Attachment subnets inside the VPC"
  type        = list(string)
  default     = [""]
}

# VPC Enable NAT Gateway (True or False)
variable "enable_nat_gateway_dev" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

# VPC Single NAT Gateway (True or False)
variable "single_nat_gateway_dev" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

# Whether to create an VPC (True or False)
variable "enable_vpc_dev" {
  description = "Whether to create an VPC"
  type        = bool
  default     = false
}

# VPC Flow Log (True or False)
variable "enable_vpc_flow_log_dev" {
  description = "Whether to create an VPC Flow Log"
  type        = bool
  default     = false
}

# S3 ARN for VPC Flow Log Destination
variable "vpc_flow_log_s3_arn_dev" {
  description = "S3 ARN for VPC Flow Log Destination"
  type        = string
  default     = ""
}
