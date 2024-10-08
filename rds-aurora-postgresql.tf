################################################################################
# RDS Aurora Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-rds-aurora
################################################################################
module "aurora-postgresql" {
  source                            = "terraform-aws-modules/rds-aurora/aws"
  create                            = var.create_aurora_postresql
  create_db_cluster_parameter_group = var.create_aurora_postresql
  create_security_group             = var.create_aurora_postresql

  name            = "rds-${var.service}-${var.environment}-${var.rds_aurora_cluster_name}"
  engine          = var.rds_aurora_cluster_engine
  engine_version  = var.rds_aurora_cluster_engine_version
  database_name   = var.rds_aurora_cluster_database_name
  master_username = var.rds_aurora_master_username
  master_password = var.rds_aurora_master_password
  port            = var.rds_aurora_port
  instances = {
    1 = {
      instance_class      = var.rds_aurora_cluster_instance_class
      publicly_accessible = false
      availability_zone   = element(local.azs, 0)
      # db_parameter_group_name = "default.aurora-postgresql14"
    }
  }
  vpc_id               = data.aws_vpc.vpc.id
  db_subnet_group_name = try(aws_db_subnet_group.rds-subnet-group[0].name, "")
  publicly_accessible  = false

  security_group_name            = "scg-${var.service}-${var.environment}-${var.rds_aurora_cluster_name}"
  security_group_use_name_prefix = false
  security_group_description     = "Aurora PostgreSQL Security Group"
  security_group_tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.rds_aurora_cluster_name}-${var.environment}"
    }
  )
  storage_encrypted                          = true
  storage_type                               = "aurora"
  kms_key_id                                 = var.create_kms_rds == true ? module.kms-rds.key_arn : data.aws_kms_key.rds[0].arn
  apply_immediately                          = true
  skip_final_snapshot                        = true
  auto_minor_version_upgrade                 = false
  backup_retention_period                    = 14
  deletion_protection                        = true
  db_cluster_parameter_group_name            = "rdspg-${var.service}-${var.environment}-${var.rds_aurora_cluster_name}"
  db_cluster_parameter_group_use_name_prefix = false
  db_cluster_parameter_group_family          = var.rds_aurora_cluster_pg_family
  db_cluster_parameter_group_description     = "aurora cluster parameter group"
  db_cluster_parameter_group_parameters = [
    # {
    #   name         = "log_min_duration_statement"
    #   value        = 4000
    #   apply_method = "immediate"
    #   }, {
    #   name         = "rds.force_ssl"
    #   value        = 1
    #   apply_method = "immediate"
    # }
  ]
  # create_db_parameter_group      = true
  # db_parameter_group_name        = "pg-${var.service}-${var.environment}-${var.rds_aurora_cluster_name}"
  # db_parameter_group_family      = "aurora-postgresql14"
  # db_parameter_group_description = "DB parameter group"
  # db_parameter_group_parameters = [
  #   {
  #     name         = "log_min_duration_statement"
  #     value        = 4000
  #     apply_method = "immediate"
  #   }
  # ]
  # enabled_cloudwatch_logs_exports = ["postgresql"]
  # create_cloudwatch_log_group     = true

  tags = merge(
    local.tags,
    {
      "Name" = "rds-${var.service}-${var.environment}-${var.rds_aurora_cluster_name}"
    },
  )
}
