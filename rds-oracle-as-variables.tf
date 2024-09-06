# RDS Name
variable "rds_oracle_as_name" {
  description = "RDS Name"
  type        = string
  default     = "oracle-as"
}

# RDS Engine
variable "rds_oracle_as_engine" {
  description = "RDS Engine"
  type        = string
  default     = "oracle-ee"
}

# RDS Engine Version
variable "rds_oracle_as_engine_version" {
  description = "RDS Engine Version"
  type        = string
  default     = "19"
}


# RDS Aurora Cluster Engine
variable "rds_oracle_as_instance_class" {
  description = "RDS Instance Class"
  type        = string
  default     = "db.t3.large"
}

# RDS Family
variable "rds_oracle_as_family" {
  description = "RDS DB parameter group"
  type        = string
  default     = "oracle-ee-19"
}

# RDS Major Engine Version
variable "rds_oracle_as_major_engine_version" {
  description = "RDS DB option group"
  type        = string
  default     = "19"
}

# RDS Allocated Storage
variable "rds_oracle_as_allocated_storage" {
  description = "RDS Allocated Storage"
  type        = number
  default     = 500
}

# RDS Name
variable "rds_oracle_as_db_name" {
  description = "RDS Database Name"
  type        = string
  default     = "oracleas"
}

# RDS Oracle As-Is Username
variable "rds_oracle_as_username" {
  description = "RDS Oracle As-Is Username"
  type        = string
  default     = ""
}

# RDS Oracle As-Is Password
variable "rds_oracle_as_password" {
  description = "RDS Oracle As-Is Password"
  type        = string
  default     = ""
}

# RDS Oracle As-Is Port
variable "rds_oracle_as_port" {
  description = "RDS Oracle As-Is Port"
  type        = number
  default     = 1521
}

# Whether to create an Oracle As-Is (True or False)
variable "enable_oracle_as" {
  description = "Whether to create an Oracle As-Is"
  type        = bool
  default     = true
}
