################################################################################
# SQS Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-sqs
################################################################################
module "sqs_app" {
  source = "terraform-aws-modules/sqs/aws"
  create = var.enable_sqs_app

  name       = "sqs-${var.service}-${var.environment}-${var.sqs_app_name}"
  fifo_queue = true

  tags = merge(
    local.tags,
    {
      "Name" = "sqs-${var.service}-${var.environment}-${var.sqs_app_name}"
    }
  )
}
