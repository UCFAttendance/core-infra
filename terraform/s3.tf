resource "random_uuid" "attendance_images" {}

resource "aws_s3_bucket" "attendance_images" {
  bucket = "attendance-images-${random_uuid.attendance_images.result}"
}

resource "aws_s3_bucket_ownership_controls" "attendance_images" {
  bucket = aws_s3_bucket.attendance_images.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "attendance_images" {
  depends_on = [aws_s3_bucket_ownership_controls.attendance_images]

  bucket = aws_s3_bucket.attendance_images.id
  acl    = "private"
}
