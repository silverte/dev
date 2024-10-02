# RDS Aurora Cluster Name
variable "rds_aurora_da_cluster_name" {
  description = "RDS Aurora Cluster Name"
  type        = string
  default     = "aurora-postgresql-da"
}

# RDS Aurora Cluster Engine
variable "rds_aurora_da_cluster_engine" {
  description = "RDS Aurora Cluster Engine"
  type        = string
  default     = "aurora-postgresql"
}

# RDS Aurora Cluster Engine Version
variable "rds_aurora_da_cluster_engine_version" {
  description = "RDS Aurora Cluster Engine Version"
  type        = string
  default     = "14.7"
}

# RDS Aurora Cluster Parameter Group Family
variable "rds_aurora_da_cluster_pg_family" {
  description = "RDS Aurora Cluster Parameter Group Family"
  type        = string
  default     = "aurora-postgresql14"
}

# RDS Aurora Cluster Instance Class
variable "rds_aurora_da_cluster_instance_class" {
  description = "RDS Aurora Cluster Instance Class"
  type        = string
  default     = ""
}

# RDS Aurora Cluster Database Name
variable "rds_aurora_da_cluster_database_name" {
  description = "RDS Aurora Cluster Database Name"
  type        = string
  default     = "testdb"
}

# RDS Aurora Master Username
variable "rds_aurora_da_master_username" {
  description = "RDS Aurora Master Username"
  type        = string
  default     = ""
}

# RDS Aurora Master Password
variable "rds_aurora_da_master_password" {
  description = "RDS Aurora Master Password"
  type        = string
  default     = ""
}

# RDS Aurora Port
variable "rds_aurora_da_port" {
  description = "RDS Aurora Port"
  type        = number
  default     = 5432
}

# Whether to create an Aurora DA PostreSQL (True or False)
variable "enable_aurora_postresql_da" {
  description = "Whether to create an Aurora DA PostreSQL"
  type        = bool
  default     = false
}
