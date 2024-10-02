# Elasticache Cluster 
variable "elasticache_cluster_name" {
  description = "Elasticache Cluster Name"
  type        = string
  default     = "data"
}

# Elasticache Cluster Engine Version
variable "elasticache_cluster_engine_version" {
  description = "Elasticache Cluster Engine Version"
  type        = string
  default     = "7.1"
}

# Elasticache Cluster Instance Class
variable "elasticache_cluster_instance_class" {
  description = "Elasticache Cluster Instance Class"
  type        = string
  default     = "cache.t4g.small"
}

# Elasticache Cluster Parameter Group Family
variable "elasticache_cluster_parameter_group_family" {
  description = "Elasticache Cluster Parameter Group Family"
  type        = string
  default     = "redis7"
}

# Elasticache Cluster Port
variable "elasticache_cluster_port" {
  description = "Elasticache Cluster Port"
  type        = number
  default     = 6379
}

# Whether to create an ElastiCache Data (True or False)
variable "create_elasticache_data" {
  description = "Whether to create an ElastiCache Data"
  type        = bool
  default     = false
}
