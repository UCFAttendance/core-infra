resource "aws_security_group" "attendance_ec2_sg" {
  name        = "attendance_ec2_sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.attendance_vpc.id

  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "attendance_ec2_sg"
  }
}

resource "aws_instance" "attendance_ec2" {
  ami                    = "ami-012967cc5a8c9f891"
  instance_type          = "t2.micro"
  key_name               = "ydhyVRfHOzEs"
  vpc_security_group_ids = [aws_security_group.attendance_ec2_sg.id]
  subnet_id              = aws_subnet.private[0].id
}

resource "aws_lb_target_group" "ec2_attendance_target_group" {
  name     = "attendance-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.attendance_vpc.id

  tags = {
    Name = "attendance-target-group"
  }
}

resource "aws_lb_target_group_attachment" "attendance_target_group_attachment" {
  target_group_arn = aws_lb_target_group.ec2_attendance_target_group.arn
  target_id        = aws_instance.attendance_ec2.id
  port             = 80
}

