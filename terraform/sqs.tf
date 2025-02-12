resource "aws_sqs_queue" "attendance_queue" {
  name = "attendance-sqs-queue"
  delay_seconds = 0
  visibility_timeout_seconds = 300
  message_retention_seconds = 345600 # 4 days 
  receive_wait_time_seconds = 20
  
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.attendance_dlq.arn
    maxReceiveCount     = 2 # only retries twice before send to dlq
  })
}

#Allow S3 bucket to write to this sqs queue
resource "aws_sqs_queue_policy" "attendance_queue_policy" {
  queue_url = aws_sqs_queue.attendance_queue.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowS3ToSendMessages"
        Effect    = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.attendance_queue.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn": aws_s3_bucket.attendance_images.arn 
          }  
        }
      }
    ]
  })
}

#For Dead-Letter-Queue: messages which could not be processed by application will be pushed here and retried
resource "aws_sqs_queue" "attendance_dlq" {
  name = "attendance_dlq"
  message_retention_seconds = 1209600 # 2 weeks
}

#Policy to allow the main queue to write to the dlq 
resource "aws_sqs_queue_policy" "attendance_dlq_policy" {
  queue_url = aws_sqs_queue.attendance_dlq.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sqs.amazonaws.com"
        }
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.attendance_dlq.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn": aws_sqs_queue.attendance_queue.arn
          }
        }
      }
    ]
  })
}
