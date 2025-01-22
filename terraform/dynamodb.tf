resource "aws_dynamodb_table" "attendance" {
  name           = "attendance"
  billing_mode   = "PAY_PER_REQUEST" # On-demand capacity mode
  hash_key       = "session_id"     # Primary partition key
  range_key      = "student_id"     # Primary sort key

  attribute {
    name = "session_id"
    type = "N" # Number type
  }

  attribute {
    name = "student_id"
    type = "N" # Number type
  }
}

