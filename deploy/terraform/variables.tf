data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

data "aws_secretsmanager_secret" "master_secrets" {
  name = "terraform-master-credentials"
}

data "aws_secretsmanager_secret_version" "master_secrets" {
  secret_id = data.aws_secretsmanager_secret.master_secrets.id
}

locals {
  aws_master_secrets = jsondecode(data.aws_secretsmanager_secret_version.master_secrets.secret_string)
}

locals {
  aws_region   = "us-east-1"
  project_name = "fase4-infra-microservices"
}