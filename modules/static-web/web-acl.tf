resource "aws_wafv2_web_acl" "waf" {
  name     = "static-web-acl"
  scope    = "CLOUDFRONT" # type of WAF scope as oppsed to sql inject
  tags     = {}
  tags_all = {}
  rule {
    name     = "static-web-rule"
    priority = 0
    action {
      allow {}
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.whitelist-ip.arn # ARN of the whitelist IPs setup 
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "static-web-rule"
      sampled_requests_enabled   = false
    }
  }
  default_action {
    block {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "static-web-acl"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_ip_set" "whitelist-ip" {
  name               = "whitelisted-ip"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.ip-addresses
}
