data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "default" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}

locals {
  vpc_id     = var.use_default_vpc ? data.aws_vpc.default.id : null
  subnet_ids = var.use_default_vpc ? data.aws_subnets.default.ids : []
}
