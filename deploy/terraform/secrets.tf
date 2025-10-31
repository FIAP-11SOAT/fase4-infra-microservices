resource "aws_secretsmanager_secret" "secrets" {
  name                    = "${local.project_name}-secrets"
  description             = "Secrets for ${local.project_name} project"
  recovery_window_in_days = 0

  tags = {
    Name = "${local.project_name}-secrets"
  }
}

resource "aws_secretsmanager_secret_version" "secrets" {
  secret_id = aws_secretsmanager_secret.secrets.id
  secret_string = jsonencode({
    VPC_ID           = module.vpc.vpc_id,
    GTW_ID           = aws_apigatewayv2_api.gtw.id,
    ECS_CLUSTER_ID   = aws_ecs_cluster.ecs_cluster.id,
    RDS_HOST         = module.rds.db_instance_address,
    RDS_PORT         = module.rds.db_instance_port,
    RDS_DATABASE     = module.rds.db_instance_name,
    RDS_USERNAME     = module.rds.db_instance_username,
    RDS_PASSWORD     = random_password.rds_password.result,
  })
}
