resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_prefix}-ecs-cluster"
}

