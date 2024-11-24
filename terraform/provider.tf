terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }

    ionosdeveloper = {
      source  = "ionos-developer/ionosdeveloper"
      version = ">= 0.1"
    }
  }
  required_version = ">= 1.1.0"
}

provider "aws" {
  region = var.aws_region
}
