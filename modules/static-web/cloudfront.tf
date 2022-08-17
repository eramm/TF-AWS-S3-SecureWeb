# Cloudfront distribution for the S3 site. OAI restricts access to the S3 bucket
resource "aws_cloudfront_distribution" "www_s3_distribution" {
  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id           = var.bucket_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }
# this enables the WAF created in web-acl.tf

  web_acl_id          = aws_wafv2_web_acl.waf.arn
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["${var.bucket_name}.${var.domain_name}"]

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 403
    response_page_path    = "/404.html"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

}


# creates the ARN that is passed to the bucket IAM rule "Origin Access Identity"
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "oai for bucket"
}