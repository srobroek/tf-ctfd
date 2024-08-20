terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63.0"
    }
  }
  backend "s3" {
    bucket = "ctfd-terraform-state-backend"
    key = "terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "terraform_tfstate"
  }
}

provider "aws" {
  region = "eu-west-1"
}


module "ctfd" {
  source = "1nval1dctf/ctfd/aws"
  app_name = "ts2024-ctfd"
  aws_region = "eu-west-1"
  create_cdn = true
  ctf_domain = "ts2024.ctfd.sjors.people.aws.dev"
  ctf_domain_zone_id = "Z06889452HK83JXUWL0Q6"
  frontend_desired_count = 3






}

