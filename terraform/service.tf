resource "aws_ecs_service" "ecs_service" {
  name            = "${var.app_prefix}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.app_target_group.arn
    container_name   = "${var.app_prefix}-container"
    container_port   = 80
  }

  depends_on = [
    aws_lb_target_group.app_target_group
  ]
}

