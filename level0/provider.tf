provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "s3_bucket_tf_state" {
  bucket = "s3-bucket-tf-state"
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "s3-bucket-tf-state"
    dynamodb_table = "terraform-state-lock-dynamo"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
