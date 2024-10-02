################################################################################
# S3 Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-s3-bucket
#            https://github.com/terraform-aws-modules/terraform-aws-s3-object
################################################################################
module "s3_bucket_app" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  create_bucket = var.create_s3_bucket_app

  bucket        = "s3-${var.service}-${var.environment}-${var.s3_bucket_app_name}"
  force_destroy = true

  tags = merge(
    local.tags,
    {
      "Name" = "s3-${var.service}-${var.environment}-${var.s3_bucket_app_name}"
    }
  )
}
