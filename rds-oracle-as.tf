################################################################################
# RDS Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-rds
################################################################################

module "rds-oracle-as" {
  source                    = "terraform-aws-modules/rds/aws"
  create_db_instance        = var.enable_oracle_as
  create_db_parameter_group = var.enable_oracle_as
  create_db_option_group    = var.enable_oracle_as

  identifier = "rds-${var.service}-${var.environment}-${var.rds_oracle_as_name}"

  engine                          = var.rds_oracle_as_engine
  engine_version                  = var.rds_oracle_as_engine_version
  family                          = var.rds_oracle_as_family               # DB parameter group
  major_engine_version            = var.rds_oracle_as_major_engine_version # DB option group
  parameter_group_name            = "rdspg-${var.service}-${var.environment}-${var.rds_oracle_as_name}"
  parameter_group_use_name_prefix = false
  parameter_group_description     = "Parameter group for ${var.service}-${var.environment}-${var.rds_oracle_as_name}"
  instance_class                  = var.rds_oracle_as_instance_class
  license_model                   = "bring-your-own-license"
  option_group_name               = "rdsopt-${var.service}-${var.environment}-${var.rds_oracle_as_name}"
  option_group_use_name_prefix    = false
  option_group_description        = "Option group for ${var.service}-${var.environment}-${var.rds_oracle_as_name}"

  storage_encrypted = true
  storage_type      = "gp3"
  # max_allocated_storage = var.rds_oracle_as_allocated_storage * 1.1
  kms_key_id        = var.enable_kms_rds == true ? module.kms-rds.key_arn : data.aws_kms_key.rds[0].arn
  allocated_storage = var.rds_oracle_as_allocated_storage

  # Make sure that database name is capitalized, otherwise RDS will try to recreate RDS instance every time
  # Oracle database name cannot be longer than 8 characters
  db_name  = var.rds_oracle_as_db_name
  username = var.rds_oracle_as_username
  password = var.rds_oracle_as_password
  port     = var.rds_oracle_as_port

  multi_az               = false
  availability_zone      = element(module.vpc.azs, 0)
  db_subnet_group_name   = module.vpc.database_subnet_group
  subnet_ids             = [element(module.vpc.database_subnets, 0)]
  vpc_security_group_ids = [module.security_group_oracle_as.security_group_id]

  # maintenance_window              = "Mon:00:00-Mon:03:00"
  # backup_window                   = "03:00-06:00"
  # enabled_cloudwatch_logs_exports = ["alert", "audit"]
  # create_cloudwatch_log_group     = true

  backup_retention_period    = 14
  skip_final_snapshot        = true
  auto_minor_version_upgrade = false
  deletion_protection        = true

  # performance_insights_enabled          = true
  # performance_insights_retention_period = 7
  # create_monitoring_role                = true

  # See here for support character sets https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.OracleCharacterSets.html
  character_set_name       = "AL32UTF8"
  nchar_character_set_name = "AL16UTF16"

  tags = merge(
    local.tags,
    {
      "Name" = "rds-${var.service}-${var.environment}-${var.rds_oracle_as_name}"
    },
  )
}

################################################################################
# RDS Automated Backups Replication Module
################################################################################

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

module "security_group_oracle_as" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  create  = var.enable_oracle_as

  name            = "scg-${var.service}-${var.environment}-${var.rds_oracle_as_name}"
  use_name_prefix = false
  description     = "Oracle security group"
  vpc_id          = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = var.rds_oracle_as_port
      to_port     = var.rds_oracle_as_port
      protocol    = "tcp"
      description = "Oracle access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-${var.rds_oracle_as_name}"
    },
  )
}
