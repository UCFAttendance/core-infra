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

output "redis-cluster" {
  value = aws_elasticache_cluster.ucf_attendance_redis
}

output "alb-arn" {
  value = aws_lb.app_load_balancer.arn
}

output "ecs-cluster-name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "backend-repository-name" {
  value = aws_ecr_repository.attendance_backend.name
}

output "attendance-images-bucket" {
  value = aws_s3_bucket.attendance_images.arn
}
