# RDS Name
variable "rds_postgresql_da_name" {
  description = "RDS Name"
  type        = string
  default     = "postgresql-da"
}

# RDS Engine
variable "rds_postgresql_da_engine" {
  description = "RDS Engine"
  type        = string
  default     = "postgres"
}

# RDS Engine Version
variable "rds_postgresql_da_engine_version" {
  description = "RDS Engine Version"
  type        = string
  default     = "14"
}

# RDS Inatance Class
variable "rds_postgresql_da_instance_class" {
  description = "RDS Instance Class"
  type        = string
  default     = ""
}

# RDS Family
variable "rds_postgresql_da_family" {
  description = "RDS DB parameter group"
  type        = string
  default     = "postgres14"
}

# RDS Major Engine Version
variable "rds_postgresql_da_major_engine_version" {
  description = "RDS DB option group"
  type        = string
  default     = "14"
}

# RDS Allocated Storage
variable "rds_postgresql_da_allocated_storage" {
  description = "RDS Allocated Storage"
  type        = number
  default     = 500
}

# RDS DB Name
variable "rds_postgresql_da_db_name" {
  description = "RDS DB Name"
  type        = string
  default     = ""
}

# RDS PostgreSQL DA Username
variable "rds_postgresql_da_username" {
  description = "RDS PostgreSQL DA Username"
  type        = string
  default     = ""
}

# RDS PostgreSQL DA Password
variable "rds_postgresql_da_password" {
  description = "RDS PostgreSQL DA Password"
  type        = string
  default     = ""
}

# RDS PostgreSQL DA Port
variable "rds_postgresql_da_port" {
  description = "RDS PostgreSQL DA Port"
  type        = number
  default     = 1521
}

# Whether to create an PostgreSQL DA (True or False)
variable "enable_postgresql_da" {
  description = "Whether to create an PostgreSQL DA"
  type        = bool
  default     = true
}
