  GNU nano 4.8                                                                               main.tf                                                                                         
# backend.tf
terraform {
  required_version = ">= 1.3.0"
  backend "s3" {
    bucket         = "my-terraform-state-bucket"   # غير الاسم باسم bucket بتاعك
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"            # غير الاسم باسم جدولك
    encrypt        = true
  }
}

# provider.tf
provider "aws" {
  region = "us-east-1"
}

# main.tf (مثال موارد بسيطة)
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-for-terraform"
  acl    = "private"
}

resource "aws_dynamodb_table" "example_lock" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

