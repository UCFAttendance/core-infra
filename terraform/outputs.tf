output "vpc-id" {
  value = aws_vpc.attendance_vpc.id
}

output "public-subnet-ids" {
  value = aws_subnet.public[*].id
}

output "private-subnet-ids" {
  value = aws_subnet.private[*].id
}

output "repository-arn" {
  value = aws_ecr_repository.attendance_backend.arn
}
