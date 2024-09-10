################################################################################
# ECR Repository
# reference: https://github.com/terraform-aws-modules/terraform-aws-ecr
################################################################################
module "ecr-app" {
  source = "terraform-aws-modules/ecr/aws"
  create = var.enable_ecr_app

  repository_name = "ecr-${var.service}-${var.environment}-${var.ecr_app_name}"

  # repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  create_lifecycle_policy = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 5 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 5
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  repository_force_delete = false

  #   # Registry Scanning Configuration
  #   manage_registry_scanning_configuration = true
  #   registry_scan_type                     = "ENHANCED"
  #   registry_scan_rules = [
  #     {
  #       scan_frequency = "SCAN_ON_PUSH"
  #       filter = [
  #         {
  #           filter      = "example1"
  #           filter_type = "WILDCARD"
  #         },
  #         { filter      = "example2"
  #           filter_type = "WILDCARD"
  #         }
  #       ]
  #       }, {
  #       scan_frequency = "CONTINUOUS_SCAN"
  #       filter = [
  #         {
  #           filter      = "example"
  #           filter_type = "WILDCARD"
  #         }
  #       ]
  #     }
  #   ]

  tags = merge(
    local.tags,
    {
      "Name" = "ecr-${var.service}-${var.environment}-${var.ecr_app_name}"
    }
  )
}

data "aws_caller_identity" "current" {}
