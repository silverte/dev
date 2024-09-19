################################################################################
# EC2 Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
################################################################################

module "ec2_meta_sharp" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.enable_ec2_meta_sharp

  name = "ec2-${var.service}-${var.environment}-meta"

  ami                         = data.aws_ami.ec2_meta_sharp.id
  instance_type               = var.ec2_meta_sharp_instance_type
  availability_zone           = element(local.azs, 0)
  subnet_id                   = element(data.aws_subnets.private.ids, 0)
  vpc_security_group_ids      = [module.security_group_ec2_meta_sharp.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = true
  # key_name                    = module.key_pair_meta_sharp.key_pair_name

  # create_iam_instance_profile = true
  # iam_role_description        = "IAM role for EC2 instance"
  # iam_role_policies = {
  #   AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  # }

  # https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/hibernating-prerequisites.html#hibernation-prereqs-supported-amis
  hibernation                 = false
  user_data_base64            = base64encode(file("./user_data.sh"))
  user_data_replace_on_change = true

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 8
    instance_metadata_tags      = "enabled"
  }

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      kms_key_id  = var.enable_kms_ebs == true ? module.kms-ebs.key_arn : data.aws_kms_key.ebs[0].arn
      volume_type = "gp3"
      #   throughput  = 200 # default: 125
      volume_size = var.ec2_meta_sharp_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name"       = "ebs-${var.service}-${var.environment}-meta-root"
          "MountPoint" = "/data"
        },
      )
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.ec2_meta_sharp_ebs_volume_size
      #   throughput  = 200 # default: 125
      encrypted  = true
      kms_key_id = var.enable_kms_ebs == true ? module.kms-ebs.key_arn : data.aws_kms_key.ebs[0].arn
      tags = merge(
        local.tags,
        {
          "Name"       = "ebs-${var.service}-${var.environment}-meta-data"
          "MountPoint" = "/data"
        },
      )
    }
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-meta"
    },
  )
}

module "security_group_ec2_meta_sharp" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"
  create  = var.enable_ec2_meta_sharp

  name            = "scg-${var.service}-${var.environment}-meta"
  use_name_prefix = false
  description     = "Security group for EC2 Nexus"
  vpc_id          = module.vpc.vpc_id

  # ingress_cidr_blocks = ["0.0.0.0/0"]
  # ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules = ["all-all"]

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-meta"
    },
  )
}

data "aws_ami" "ec2_meta_sharp" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ec2_meta_sharp_ami_filter_value]
  }
}
