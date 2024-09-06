# RDS Name
variable "rds_mariadb_as_name" {
  description = "RDS Name"
  type        = string
  default     = "mariadb-as"
}

# RDS Engine
variable "rds_mariadb_as_engine" {
  description = "RDS Engine"
  type        = string
  default     = "mariadb"
}

# RDS Engine Version
variable "rds_mariadb_as_engine_version" {
  description = "RDS Engine Version"
  type        = string
  default     = "10.11.8"
}

# RDS Inatance Class
variable "rds_mariadb_as_instance_class" {
  description = "RDS Instance Class"
  type        = string
  default     = ""
}

# RDS Family
variable "rds_mariadb_as_family" {
  description = "RDS DB parameter group"
  type        = string
  default     = "mariadb10.11"
}

# RDS Major Engine Version
variable "rds_mariadb_as_major_engine_version" {
  description = "RDS DB option group"
  type        = string
  default     = "10.11"
}

# RDS Allocated Storage
variable "rds_mariadb_as_allocated_storage" {
  description = "RDS Allocated Storage"
  type        = number
  default     = 500
}

# RDS DB Name
variable "rds_mariadb_as_db_name" {
  description = "RDS DB Name"
  type        = string
  default     = ""
}

# RDS MariaDB As-Is Username
variable "rds_mariadb_as_username" {
  description = "RDS MariaDB As-Is Username"
  type        = string
  default     = ""
}

# RDS MariaDB As-Is Password
variable "rds_mariadb_as_password" {
  description = "RDS MariaDB As-Is Password"
  type        = string
  default     = ""
}

# RDS MariaDB As-Is Port
variable "rds_mariadb_as_port" {
  description = "RDS MariaDB As-Is Port"
  type        = number
  default     = 3306
}

# Whether to create an MariaDB As-Is (True or False)
variable "enable_mariadb_as" {
  description = "Whether to create an MariaDB As-Is"
  type        = bool
  default     = true
}
