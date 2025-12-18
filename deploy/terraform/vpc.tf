# locals {
#   vpc_cidr = "10.0.0.0/16"
#   azs      = slice(data.aws_availability_zones.available.names, 0, 3)
# }
#
# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "~> 6.0"
#
#   name = "${local.project_name}-vpc"
#   cidr = local.vpc_cidr
#
#   azs             = local.azs
#   private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
#   public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
#
#   enable_nat_gateway = true
#   single_nat_gateway = true
#
#   public_subnet_tags = {
#     "Tier" = "public"
#   }
#
#   private_subnet_tags = {
#     "Tier" = "private"
#   }
#
#   tags = {
#     Name = "${local.project_name}-vpc"
#   }
# }
