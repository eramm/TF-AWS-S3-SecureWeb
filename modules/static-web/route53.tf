# setup bucketname.domain to alias to clodfrnt

#see acm.tf line 10 for data.zone source

resource "aws_route53_record" "www-a" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.bucket_name}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.www_s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.www_s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}