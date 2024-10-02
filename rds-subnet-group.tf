# Database subnet group for vpc-esp-dev
resource "aws_db_subnet_group" "rds-subnet-group" {
  count       = var.create_db_subnet_group ? 1 : 0
  name        = "rdssg-${var.service}-${var.environment}"
  description = "Database subnet group for vpc-esp-dev"
  subnet_ids  = data.aws_subnets.database.ids
  tags = merge(
    local.tags,
    {
      Name = "rdssg-${var.service}-${var.environment}"
    },
  )
}
