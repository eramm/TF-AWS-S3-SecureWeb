# creates a certificate related to your domain name. if you already have a cert there is no need


provider "aws" {
  region = "us-east-1"
}

# provides zone info to R53

data "aws_route53_zone" "zone" {
  name = var.domain_name
}

# SSL Certificate
resource "aws_acm_certificate" "ssl_certificate" {
  # provider = aws.acm_provider
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# dvo is just a variable name. here looping through acn fields to put in route53 to validate the cert.
# to validate the cert its info must be interrted into route53
# RTFM !! https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate

# domain_name comes from the aws_acm_certificate resource

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

# Uncomment the validation_record_fqdns line if you do DNS validation instead of Email.
resource "aws_acm_certificate_validation" "cert_validation" {
  # provider = aws.acm_provider
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}