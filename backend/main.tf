terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63.0"
    }

  }

/*  backend "s3" {
    bucket = "ctfd-terraform-state-backend"
    key = "terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "terraform_tfstate"
  }*/
}

provider "aws" {
  region = "eu-west-1"
}


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

