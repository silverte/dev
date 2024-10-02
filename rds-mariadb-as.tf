################################################################################
# RDS Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-rds
################################################################################
module "rds-maria-as" {
  source                    = "terraform-aws-modules/rds/aws"
  create_db_instance        = var.enable_mariadb_as
  create_db_parameter_group = var.enable_mariadb_as
  create_db_option_group    = var.enable_mariadb_as

  identifier = "rds-${var.service}-${var.environment}-${var.rds_mariadb_as_name}"

  engine                          = var.rds_mariadb_as_engine
  engine_version                  = var.rds_mariadb_as_engine_version
  family                          = var.rds_mariadb_as_family               # DB parameter group
  major_engine_version            = var.rds_mariadb_as_major_engine_version # DB option group
  parameter_group_name            = "rdspg-${var.service}-${var.environment}-${var.rds_mariadb_as_name}"
  parameter_group_use_name_prefix = false
  parameter_group_description     = "MariaDB parameter group for ${var.service}-${var.environment}-${var.rds_mariadb_as_name}"
  instance_class                  = var.rds_mariadb_as_instance_class
  option_group_name               = "rdsog-${var.service}-${var.environment}-${var.rds_mariadb_as_name}"
  option_group_use_name_prefix    = false
  option_group_description        = "MariaDB option group for ${var.service}-${var.environment}-${var.rds_mariadb_as_name}"

  storage_encrypted = true
  storage_type      = "gp3"
  # max_allocated_storage = var.rds_mariadb_as_allocated_storage * 1.1
  kms_key_id        = var.enable_kms_rds == true ? module.kms-rds.key_arn : data.aws_kms_key.rds[0].arn
  allocated_storage = var.rds_mariadb_as_allocated_storage

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = var.rds_mariadb_as_db_name
  username = var.rds_mariadb_as_username
  password = var.rds_mariadb_as_password
  port     = var.rds_mariadb_as_port

  multi_az               = false
  availability_zone      = element(local.azs, 0)
  db_subnet_group_name   = try(aws_db_subnet_group.rds-subnet-group[0].name, "")
  subnet_ids             = [element(data.aws_subnets.database.ids, 0)]
  vpc_security_group_ids = [module.security_group_rds_maria_as.security_group_id]

  #   maintenance_window              = "Mon:00:00-Mon:03:00"
  #   backup_window                   = "03:00-06:00"
  #   enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  #   create_cloudwatch_log_group     = true

  backup_retention_period    = 14
  skip_final_snapshot        = true
  auto_minor_version_upgrade = false
  deletion_protection        = true

  #   performance_insights_enabled          = true
  #   performance_insights_retention_period = 7
  #   create_monitoring_role                = true
  #   monitoring_interval                   = 60
  #   monitoring_role_name                  = "example-monitoring-role-name"
  #   monitoring_role_use_name_prefix       = true
  #   monitoring_role_description           = "Description for monitoring role"

  #   parameters = [
  #     {
  #       name  = "autovacuum"
  #       value = 1
  #     },
  #     {
  #       name  = "client_encoding"
  #       value = "utf8"
  #     }
  #   ]

  tags = merge(
    local.tags,
    {
      "Name" = "rds-${var.service}-${var.environment}-${var.rds_mariadb_as_name}"
    },
  )
}

# ################################################################################
# # RDS Automated Backups Replication Module
# ################################################################################

# provider "aws" {
#   alias  = "region2"
#   region = local.region2
# }

# module "kms" {
#   source      = "terraform-aws-modules/kms/aws"
#   version     = "~> 1.0"
#   description = "KMS key for cross region automated backups replication"

#   # Aliases
#   aliases                 = [local.name]
#   aliases_use_name_prefix = true

#   key_owners = [data.aws_caller_identity.current.arn]

#   tags = local.tags

#   providers = {
#     aws = aws.region2
#   }
# }

# module "db_automated_backups_replication" {
#   source = "../../modules/db_instance_automated_backups_replication"

#   source_db_instance_arn = module.db.db_instance_arn
#   kms_key_arn            = module.kms.key_arn

#   providers = {
#     aws = aws.region2
#   }
# }

################################################################################
# Supporting Resources
################################################################################

module "security_group_rds_maria_as" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.enable_mariadb_as

  name            = "scg-${var.service}-${var.environment}-${var.rds_mariadb_as_name}"
  use_name_prefix = false
  description     = "PostgreSQL example security group"
  vpc_id          = data.aws_vpc.dev.id

  # ingress
  ingress_with_cidr_blocks = [
    {
      # from_port   = var.rds_mariadb_as_port
      # to_port     = var.rds_mariadb_as_port
      # protocol    = "tcp"
      # description = "PostgreSQL access from within VPC"
      # cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-${var.rds_mariadb_as_name}"
    },
  )
}
