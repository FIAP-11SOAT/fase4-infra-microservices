resource "aws_lb" "ecs_alb" {
  name               = md5("${local.project_name}-ecs-internal-alb")
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.private_subnets

  tags = {
    Name = "${local.project_name}-eks-alb"
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Default response from ALB"
      status_code  = "404"
    }
  }
}
