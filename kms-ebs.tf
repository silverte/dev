################################################################################
# KMS Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-kms
################################################################################
module "kms-ebs" {
  source = "terraform-aws-modules/kms/aws"
  create = var.create_kms_ebs

  description             = "EBS customer managed key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = false

  # Policy
  enable_default_policy = true
  #key_administrators                 = ["arn:aws:iam::012345678901:role/admin"]

  # Aliases
  aliases = ["ebs"]

  tags = merge(
    local.tags,
    {
      "Name" = "kms-${var.service}-ebs"
    }
  )
}
