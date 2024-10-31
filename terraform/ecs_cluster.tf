resource "aws_ecs_cluster" "ucf-attendance" {
  name = "${var.app_prefix}-ecs-cluster"
}


