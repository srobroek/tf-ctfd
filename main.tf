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

data "aws_route53_zone" "zone"{
  zone_id = var.domain_zone_id
}

resource "aws_acm_certificate" "certificate" {
  domain_name = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options: dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  ttl = 60
  type = each.value.type
  zone_id = data.aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "cert_vaidation" {
  timeouts {
    create = "5m"
  }
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_record: record.fqdn]
}







module "ctfd" {
  source = "1nval1dctf/ctfd/aws"
  app_name = "ts2024-ctfd"
  aws_region = "eu-west-1"
  create_cdn = true
  ctf_domain = "ts2024.ctfd.sjors.people.aws.dev"
  ctf_domain_zone_id = data.aws_route53_zone.zone.zone_id
  frontend_desired_count = 3
  https_certificate_arn = aws_acm_certificate.certificate.arn






}

