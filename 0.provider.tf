provider "aws" {
  region = local.region
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       command     = "aws"
#       # This requires the awscli to be installed locally where Terraform is executed
#       args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
#     }
#   }
# }

# provider "kubectl" {
#   apply_retry_count      = 5
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   load_config_file       = false

#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     # This requires the awscli to be installed locally where Terraform is executed
#     args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
#   }
# }

data "aws_availability_zones" "available" {}
data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}
# management에서 생성된 KMS 키의 ARN 또는 동일 계정에서 생성한 Alias를 사용하여 Data Source를 정의
data "aws_kms_key" "ebs" {
  count  = var.enable_kms_ebs == true ? 0 : 1
  key_id = var.enable_kms_ebs == true ? "alias/ebs" : var.management_ebs_key_arn
}
data "aws_kms_key" "rds" {
  count  = var.enable_kms_rds == true ? 0 : 1
  key_id = var.enable_kms_ebs == true ? "alias/rds" : var.management_rds_key_arn
}
