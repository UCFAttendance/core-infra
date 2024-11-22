resource "aws_ecr_repository" "backend" {
  name = "attendance/backend"
}

resource "aws_ecr_lifecycle_policy" "backend" {
  repository = aws_ecr_repository.attendance_backend.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 7 images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["v"],
        "countType": "imageCountMoreThan",
        "countNumber": 7
      },
      "action": {
        "type": "expire"
      }
    }
  ]
} 
EOF
}
