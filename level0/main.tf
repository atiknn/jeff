
resource "aws_s3_bucket" "s3_bucket_tf_state" {
  bucket = "terraformstatebucketl1"
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraformstatedynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

