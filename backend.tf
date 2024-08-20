resource "aws_s3_bucket" "bucket" {
  bucket = "ctfd-terraform-state-backend"
  object_lock_enabled = true
  tags = {
    Name = "S3 Terraform State"
  }
}

resource "aws_dynamodb_table" "terraform-lock" {
  name = "terraform_tfstate"
  read_capacity = 1
  write_capacity = 1
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}