# ECS Task Definition
resource "aws_ecs_task_definition" "example" {
  family                   = "${var.app_prefix}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "${var.app_prefix}-container"
      image     = "nginx"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

  tags = {
    Name = "${var.app_prefix}-task-definition"
  }
}

# ECS Service
resource "aws_ecs_service" "example" {
  name            = "${var.app_prefix}-service"
  cluster         = aws_ecs_cluster.example.id  # Referencing the ECS cluster defined earlier
  task_definition = aws_ecs_task_definition.example.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = aws_subnet.public.*.id   # Using the public subnets created earlier
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn  # Referencing the target group created in load_balancer.tf
    container_name   = "${var.app_prefix}-container"
    container_port   = 80
  }

  tags = {
    Name = "${var.app_prefix}-ecs-service"
  }
}

# Security Group for ECS Tasks
resource "aws_security_group" "ecs_sg" {
  name        = "${var.app_prefix}-ecs-sg"
  description = "Allow HTTP traffic for ECS tasks"
  vpc_id      = aws_vpc.attendance_vpc.id  # Referencing the VPC created earlier

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_prefix}-ecs-sg"
  }
}

