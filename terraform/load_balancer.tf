resource "aws_lb" "app_load_balancer" {
  name               = "${var.app_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public[*].id // references all public subnets

  tags = {
    Name = "${var.app_prefix}-alb"
  }
}

resource "aws_lb_target_group" "app_target_group" {
  name     = "${var.app_prefix}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.attendance_vpc.id // set the VPC ID here using the reference

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "${var.app_prefix}-lb-sg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.attendance_vpc.id // set the VPC ID here using the reference

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
}
