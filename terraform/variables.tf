variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region to deploy to"
}

variable "certificate_arn" {
  default     = "arn:aws:acm:us-east-1:354918382277:certificate/7489e6b1-9248-4bda-a547-2711eb7c3f8f"
  description = "The ARN of the SSL certificate to use for HTTPS"
}
