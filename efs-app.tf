################################################################################
# EFS Module
################################################################################

module "efs-app" {
  source = "terraform-aws-modules/efs/aws"
  create = var.enable_efs_app

  # File system
  name           = "efs-${var.service}-${var.environment}-${var.efs_app_name}"
  creation_token = "efs-${var.service}-${var.environment}-${var.efs_app_name}"
  encrypted      = true
  # Used to create a file system that uses One Zone storage classes
  availability_zone_name = module.vpc.azs[0]

  # performance_mode = "maxIO"
  # NB! PROVISIONED TROUGHPUT MODE WITH 256 MIBPS IS EXPENSIVE ~$1500/month
  # throughput_mode                 = "provisioned"
  # provisioned_throughput_in_mibps = 256

  lifecycle_policy = {
    transition_to_ia                    = "AFTER_30_DAYS"
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }

  # File system policy
  attach_policy = false
  # bypass_policy_lockout_safety_check = false
  # policy_statements = [
  #   {
  #     sid     = "Example"
  #     actions = ["elasticfilesystem:ClientMount"]
  #     principals = [
  #       {
  #         type        = "AWS"
  #         identifiers = [data.aws_caller_identity.current.arn]
  #       }
  #     ]
  #   }
  # ]

  # Mount targets / security group
  # mount_targets                  = { for k, v in zipmap(local.azs, module.vpc.private_subnets) : k => { subnet_id = v } }
  # one zone class only!
  mount_targets = {
    "${local.azs[0]}" = {
      subnet_id = module.vpc.private_subnets[0]
    }
  }
  security_group_name            = "scg-${var.service}-${var.environment}-efs-${var.efs_app_name}"
  security_group_use_name_prefix = false
  security_group_description     = "EFS security group"
  security_group_vpc_id          = module.vpc.vpc_id
  security_group_rules = {
    vpc = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  }

  # Access point(s)
  # access_points = {
  #   posix_example = {
  #     name = "posix-example"
  #     posix_user = {
  #       gid            = 1001
  #       uid            = 1001
  #       secondary_gids = [1002]
  #     }

  #     tags = {
  #       Additionl = "yes"
  #     }
  #   }
  #   root_example = {
  #     root_directory = {
  #       path = "/example"
  #       creation_info = {
  #         owner_gid   = 1001
  #         owner_uid   = 1001
  #         permissions = "755"
  #       }
  #     }
  #   }
  # }

  # Backup policy
  enable_backup_policy = false

  # Replication configuration
  # create_replication_configuration = true
  # replication_configuration_destination = {
  #   region = "eu-west-2"
  # }

  tags = merge(
    local.tags,
    {
      "Name" = "efs-${var.service}-${var.environment}-${var.efs_app_name}"
    }
  )
}
