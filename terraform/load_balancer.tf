resource "aws_lb" "app_load_balancer" {
  name               = "attendance-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public[*].id

  tags = {
    Name = "attendance-alb"
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "application/json"
      message_body = "{\"message\": \"Resource not found\"}"
      status_code  = "200"
    }
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "attendance-lb-sg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.attendance_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
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
