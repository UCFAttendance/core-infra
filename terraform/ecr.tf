resource "aws_ecr_repository" "attendance" {
  name                 = "attendance"
  image_tag_mutability = "MUTABLE"
}
