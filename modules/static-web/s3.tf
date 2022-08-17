data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "PublicReadObject"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

# principals needed for cloudfront to access the S3 bucket. It blocks the bucket from public access and made only available to CloudFront

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }

  }
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

# S3 bucket for website.
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"

#Various rules to allow cross origin access but only from CloudFrint # allowed origins is the endpoint used by cloudfront
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://${var.bucket_name}.${var.domain_name}"]
    max_age_seconds = 3000
  }

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false

      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}