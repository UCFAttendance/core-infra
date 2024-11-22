output "vpc-id" {
  value = aws_vpc.attendance_vpc.id
}

output "public-subnet-ids" {
  value = aws_subnet.public[*].id
}

output "private-subnet-ids" {
  value = aws_subnet.private[*].id
}

output "rds-indentifier" {
  value = aws_db_instance.ucf_attendance_db.identifier
}

output "alb-arn" {
  value = aws_lb.app_load_balancer.arn
}

output "ecs-cluster-name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "repository-arn" {
  value = aws_ecr_repository.attendance_backend.arn
}
