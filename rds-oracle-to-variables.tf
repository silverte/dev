# RDS Name
variable "rds_oracle_to_name" {
  description = "RDS Name"
  type        = string
  default     = "oracle-to"
}

# RDS Engine
variable "rds_oracle_to_engine" {
  description = "RDS Engine"
  type        = string
  default     = "oracle-ee"
}

# RDS Engine Version
variable "rds_oracle_to_engine_version" {
  description = "RDS Engine Version"
  type        = string
  default     = "19"
}


# RDS Aurora Cluster Engine
variable "rds_oracle_to_instance_class" {
  description = "RDS Instance Class"
  type        = string
  default     = "db.t3.large"
}

# RDS Family
variable "rds_oracle_to_family" {
  description = "RDS DB parameter group"
  type        = string
  default     = "oracle-ee-19"
}

# RDS Major Engine Version
variable "rds_oracle_to_major_engine_version" {
  description = "RDS DB option group"
  type        = string
  default     = "19"
}

# RDS Allocated Storage
variable "rds_oracle_to_allocated_storage" {
  description = "RDS Allocated Storage"
  type        = number
  default     = 500
}

# RDS Name
variable "rds_oracle_to_db_name" {
  description = "RDS Database Name"
  type        = string
  default     = "oracleto"
}

# RDS Oracle To-Be Username
variable "rds_oracle_to_username" {
  description = "RDS Oracle To-Be Username"
  type        = string
  default     = ""
}

# RDS Oracle To-Be Password
variable "rds_oracle_to_password" {
  description = "RDS Oracle To-Be Password"
  type        = string
  default     = ""
}

# RDS Oracle To-Be Port
variable "rds_oracle_to_port" {
  description = "RDS Oracle To-Be Port"
  type        = number
  default     = 1521
}

# Whether to create an Oracle To-Be (True or False)
variable "enable_oracle_to" {
  description = "Whether to create an Oracle To-Be"
  type        = bool
  default     = false
}
