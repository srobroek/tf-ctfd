terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63.0"
    }

    ctfd = {
      source = "registry.terraform.io/ctfer-io/ctfd"
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

provider "aws" {
  alias = "acm"
  region = "us-east-1"
}

data "aws_route53_zone" "zone"{
  zone_id = var.domain_zone_id
}





module "certificate" {
  source = "./modules/certificate"
  domain_name = var.domain_name
  domain_zone_id = var.domain_zone_id

}



module "ctfd" {
  source = "1nval1dctf/ctfd/aws"
  app_name = var.app_name
  frontend_desired_count = var.frontend_desired_count
  aws_region = var.region
  create_cdn = true
  ctf_domain = var.domain_name
  ctf_domain_zone_id = data.aws_route53_zone.zone.zone_id
  https_certificate_arn = module.certificate.arn
  db_serverless = true






}



