# Application Load Balancer
resource "aws_lb" "ecs_lb" {
  name               = "${var.app_prefix}-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public.*.id  # Using the public subnets created earlier

  enable_deletion_protection = false

  tags = {
    Name = "${var.app_prefix}-lb"
  }
}

# Target Group for ECS
resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.app_prefix}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.attendance_vpc.id  # Referencing the VPC created earlier
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.app_prefix}-tg"
  }
}

# Listener for Load Balancer
resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }

  tags = {
    Name = "${var.app_prefix}-listener"
  }
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.app_prefix}-alb-sg"
  description = "Allow HTTP traffic for ALB"
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
    Name = "${var.app_prefix}-alb-sg"
  }
}

