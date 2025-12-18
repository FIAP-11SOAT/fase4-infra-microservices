# resource "aws_ecs_cluster" "ecs_cluster" {
#   name = "${local.project_name}-ecs-cluster"
#
#   tags = {
#     Name = "${local.project_name}-ecs-cluster"
#   }
# }