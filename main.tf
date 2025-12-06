# main.tf

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket         = "my-terraform-state-bucket"  # غيّر الاسم لو مطلوب
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

# S3 bucket لإنشاء الباكيند لو مش موجود
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"  # نفس الاسم في backend
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "TerraformStateBucket"
    Environment = "Dev"
  }
}

# DynamoDB table لتأمين state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"  # نفس الاسم في backend
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "TerraformLocks"
    Environment = "Dev"
  }
}
