# Create VPC using Terraform Module
module "vpc" {
  source     = "terraform-aws-modules/vpc/aws"
  version    = "5.8.1"
  create_vpc = var.enable_vpc

  # Details
  name            = "vpc-${var.service}-${var.environment}"
  cidr            = var.cidr
  azs             = local.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  intra_subnets   = var.infra_subnets

  manage_default_route_table    = false
  manage_default_network_acl    = false
  manage_default_security_group = false
  manage_default_vpc            = false

  # Tag subnets
  public_subnet_names   = ["sub-${var.service}-${var.environment}-pub-a", "sub-${var.service}-${var.environment}-pub-c"]
  private_subnet_names  = ["sub-${var.service}-${var.environment}-pri-a", "sub-${var.service}-${var.environment}-pri-c"]
  database_subnet_names = ["sub-${var.service}-${var.environment}-db-a", "sub-${var.service}-${var.environment}-db-c"]
  intra_subnet_names    = ["sub-${var.service}-${var.environment}-ep-a", "sub-${var.service}-${var.environment}-ep-c"]

  # Tag route table
  public_route_table_tags   = { "Name" : "route-${var.service}-${var.environment}-pub" }
  private_route_table_tags  = { "Name" : "route-${var.service}-${var.environment}-pri" }
  database_route_table_tags = { "Name" : "route-${var.service}-${var.environment}-db" }
  intra_route_table_tags    = { "Name" : "route-${var.service}-${var.environment}-ep" }

  igw_tags = { "Name" : "igw-${var.service}-${var.environment}" }

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  nat_gateway_tags   = { "Name" : "nat-${var.service}-${var.environment}" }
  nat_eip_tags       = { "Name" : "eip-${var.service}-${var.environment}" }

  database_subnets                   = var.database_subnets
  create_database_subnet_group       = var.create_database_subnet_group
  create_database_subnet_route_table = var.create_database_subnet_route_table
  database_subnet_group_name         = "rdssg-${var.service}-${var.environment}"
  database_subnet_group_tags         = { "Name" = "rdssg-${var.service}-${var.environment}" }

  # DNS Parameters in VPC
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = "eks-${var.service}-${var.environment}"
  }

  # tags for the VPC
  tags = local.tags

}

# Fully private cluster only
# module "vpc_endpoints" {
#   source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version = "~> 5.1"

#   vpc_id = module.vpc.vpc_id

#   # Security group
#   create_security_group      = true
#   security_group_name_prefix = "${local.name}-vpc-endpoints-"
#   security_group_description = "VPC endpoint security group"
#   security_group_rules = {
#     ingress_https = {
#       description = "HTTPS from VPC"
#       cidr_blocks = [module.vpc.vpc_cidr_block]
#     }
#   }

#   endpoints = merge({
#     s3 = {
#       service         = "s3"
#       service_type    = "Gateway"
#       route_table_ids = module.vpc.infra_route_table_ids
#       tags = {
#         Name = "${local.name}-s3"
#       }
#     }
#     },
#     { for service in toset(["autoscaling", "ecr.api", "ecr.dkr", "ec2", "ec2messages", "elasticloadbalancing", "sts", "kms", "logs", "ssm", "ssmmessages"]) :
#       replace(service, ".", "_") =>
#       {
#         service             = service
#         subnet_ids          = module.vpc.infra_subnet
#         private_dns_enabled = true
#         tags                = { Name = "${local.name}-${service}" }
#       }
#   })

#   tags = local.tags
# }
