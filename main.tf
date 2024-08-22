terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63.0"
    }

    ctfd = {
      source = "ctfer-io/ctfd"
      version = "1.0.0"
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
  region = var.region
}



provider "aws" {
  alias = "acm"
  region = "us-east-1"
}

/*provider "ctfd" {
  url = "https://ts2024.ctfd.sjors.people.aws.dev"

}*/

data "aws_route53_zone" "zone"{
  zone_id = var.domain_zone_id
  count = var.domain_zone_id && var.domain_name ? 1: 0
}





module "certificate" {
  source = "./modules/certificate"
  domain_name = var.domain_name
  domain_zone_id = var.domain_zone_id
  count = var.domain_zone_id && var.domain_name ? 1: 0
}



module "ctfd" {
  source = "1nval1dctf/ctfd/aws"
  app_name = var.app_name
  frontend_desired_count = var.frontend_desired_count
  aws_region = var.region
  create_cdn = true
  ctf_domain = var.domain_name ? var.domain_name: null
  ctf_domain_zone_id = var.domain_zone_id ? data.aws_route53_zone.zone.zone_id : null
  https_certificate_arn = var.domain_name ? module.certificate.arn : null
  db_serverless = true






}

/*module "ctfd-challenges" {
  source = "./modules/ctfd-challenges"
}
*/


