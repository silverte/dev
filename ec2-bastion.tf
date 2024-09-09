################################################################################
# EC2 Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
################################################################################

module "ec2_bastion" {
  source = "terraform-aws-modules/ec2-instance/aws"
  create = var.enable_ec2_bastion

  name = "ec2-${var.service}-${var.environment}-bastion"

  ami                         = data.aws_ami.ec2_bastion.id
  instance_type               = var.ec2_bastion_instance_type
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.security_group_ec2_bastion.security_group_id]
  associate_public_ip_address = true
  disable_api_stop            = false
  # key_name                    = module.key_pair_bastion.key_pair_name

  create_iam_instance_profile = true
  iam_role_name               = "role-${var.service}-${var.environment}-bastion-instance-profile"
  iam_role_use_name_prefix    = false
  iam_role_tags = merge(
    local.tags,
    {
      "Name" = "role-${var.service}-${var.environment}-bastion-instance-profile"
    },
  )
  iam_role_description = "IAM role for EC2 instance"
  iam_role_policies = {
    AmazonEKSClusterPolicy = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    # AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

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
      volume_size = var.ec2_bastion_root_volume_size
      tags = merge(
        local.tags,
        {
          "Name"       = "ebs-${var.service}-${var.environment}-bastion-root"
          "MountPoint" = "/data"
        },
      )
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = var.ec2_bastion_ebs_volume_size
      #   throughput  = 200 # default: 125
      encrypted  = true
      kms_key_id = var.enable_kms_ebs == true ? module.kms-ebs.key_arn : data.aws_kms_key.ebs[0].arn
      tags = merge(
        local.tags,
        {
          "Name"       = "ebs-${var.service}-${var.environment}-bastion-data"
          "MountPoint" = "/data"
        },
      )
    }
  ]

  tags = merge(
    local.tags,
    {
      "Name" = "ec2-${var.service}-${var.environment}-bastion"
    },
  )
}

module "security_group_ec2_bastion" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"
  create  = var.enable_ec2_bastion

  name            = "scg-${var.service}-${var.environment}-bastion"
  use_name_prefix = false
  description     = "Security group for EC2 Bastion"
  vpc_id          = module.vpc.vpc_id

  # ingress_cidr_blocks = ["0.0.0.0/0"]
  # ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules = ["all-all"]

  tags = merge(
    local.tags,
    {
      "Name" = "scg-${var.service}-${var.environment}-bastion"
    },
  )
}

data "aws_ami" "ec2_bastion" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ec2_bastion_ami_filter_value]
  }
}
# Key pair
# module "key_pair_bastion" {
#   source = "terraform-aws-modules/key-pair/aws"
#   create = var.enable_ec2_bastion

#   key_name           = "key-${var.service}-${var.environment}-bastion"
#   create_private_key = true

#   tags = merge(
#     local.tags,
#     {
#       "Name" = "key-${var.service}-${var.environment}-bastion"
#     },
#   )
# }

# resource "local_file" "save_private_key" {
#   count           = var.enable_ec2_bastion ? 1 : 0
#   content         = try(trimspace(module.key_pair_bastion.private_key_pem), "")
#   filename        = "${path.module}/key-${var.service}-${var.environment}-bastion.pem"
#   file_permission = "0400" # 파일 권한 설정 (옵션)
# }
