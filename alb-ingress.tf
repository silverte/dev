module "security_group_alb_ingress" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"
  create  = var.enable_alb

  name            = "scg-${var.service}-${var.environment}-alb-ingress"
  use_name_prefix = false
  description     = "Security group for ALB ingress "
  vpc_id          = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-alb-ingress"
    },
  )
}
