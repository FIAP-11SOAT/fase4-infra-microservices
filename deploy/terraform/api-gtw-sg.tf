resource "aws_security_group" "vpc_link_sg" {
  name        = "${local.project_name}-ecs-vpc-link-sg"
  description = "Security Group for API Gateway VPC Link"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP from VPC CIDR"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    description = "Allow HTTP to ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = {
    Name = "${local.project_name}-ecs-vpc-link-sg"
  }
}
