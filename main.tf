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

/*provider "ctfd" {
  url = "https://ts2024.ctfd.sjors.people.aws.dev"

}*/

data "aws_route53_zone" "zone"{
  zone_id = var.domain_zone_id
  count = var.domain_zone_id ? 1: 0

}





module "certificate" {
  source = "./modules/certificate"
  domain_name = var.domain_name
  domain_zone_id = var.domain_zone_id
  count = var.domain_zone_id && var.domain_name ? 1: 0
  providers = {
    aws = aws.acm
  }
}



module "ctfd" {
  source = "1nval1dctf/ctfd/aws"
  app_name = var.app_name
  frontend_desired_count = var.frontend_desired_count
  aws_region = var.region
  create_cdn = true
  ctf_domain = var.domain_name != null ? var.domain_name: null
  ctf_domain_zone_id = var.domain_zone_id != null ? data.aws_route53_zone.zone[0].zone_id : null
  https_certificate_arn = var.domain_name != null ? module.certificate.arn : null
  db_serverless = true


}

/*data "aws_ecs_cluster" "ctfd-cluster" {
  cluster_name = "${var.app_name}-ctfd"
}

data "aws_ecs_service" "ctfd" {
  service_name = var.app_name
  cluster_arn  = data.aws_ecs_cluster.ctfd-cluster.arn
}*/





/*module "ctfd-challenges" {
  source = "./modules/ctfd-challenges"

}
*/


