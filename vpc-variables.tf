# VPC Name
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "vpc"
}

# VPC CIDR Block
variable "cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

# VPC Public Subnets
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = [""]
}

# VPC Private Subnets
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = [""]
}

# VPC Infra Subnets
variable "infra_subnets" {
  description = "A list of infra subnets inside the VPC"
  type        = list(string)
  default     = [""]
}

# VPC Database Subnets
variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = [""]
}

# VPC Create Database Subnet Group (True / False)
variable "create_database_subnet_group" {
  description = "VPC Create Database Subnet Group, Controls if database subnet group should be created"
  type        = bool
  default     = true
}

# VPC Create Database Subnet Route Table (True or False)
variable "create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table, Controls if separate route table for database should be created"
  type        = bool
  default     = true
}


# VPC Enable NAT Gateway (True or False)
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

# VPC Single NAT Gateway (True or False)
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

# Whether to create an VPC (True or False)
variable "enable_vpc" {
  description = "Whether to create an VPC"
  type        = bool
  default     = true
}
