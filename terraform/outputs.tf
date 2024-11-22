output "vpc-id" {
  value = aws_vpc.attendance_vpc.id
}

output "public-subnet-ids" {
  value = aws_subnet.public[*].id
}

output "private-subnet-ids" {
  value = aws_subnet.private[*].id
}

output "rds-endpoint" {
  value = aws_db_instance.ucf_attendance_db.endpoint
}

output "alb-id" {
  value = aws_lb.app_load_balancer.id
}

output "ecs-cluster-id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "repository-arn" {
  value = aws_ecr_repository.attendance_backend.arn
}
