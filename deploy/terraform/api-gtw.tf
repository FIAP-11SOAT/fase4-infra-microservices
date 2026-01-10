resource "aws_apigatewayv2_api" "gtw" {
  name          = "${local.project_name}-api-gateway"
  protocol_type = "HTTP"
  cors_configuration {
    allow_headers = ["*"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  tags = {
    Name = "${local.project_name}-api-gateway"
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.gtw.id
  name        = "$default"
  auto_deploy = true

  tags = {
    Name = "${local.project_name}-api-gateway-stage"
  }
}