resource "aws_security_group" "alb_sg" {
  name        = "${local.project_name}-ecs-alb-sg"
  description = "Security Group for internal ALB in ECS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow HTTP from VPC Link SG"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc_link_sg.id]
  }

  egress {
    description = "Allow all outbound traffic to VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = {
    Name = "${local.project_name}-ecs-alb-sg"
    Tier = "alb/internal"
  }
}