# CloudFront origin access control for S3 bucket using sigv4 signing protocol
resource "aws_cloudfront_origin_access_control" "www" {
  name = "${local.name.prefix} cloudfront OAC"
  description = "${local.name.prefix} static website cloudfront OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

# Cloudfront distribution with S3 as origin, HTTPS redirect, IPv6, ACM SSL cert, and NO CACHE (to avoid invalidation issues)
resource "aws_cloudfront_distribution" "www" {
  depends_on = [ aws_s3_bucket.www, aws_cloudfront_origin_access_control.www ]

  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.www.bucket_domain_name
    origin_id = aws_s3_bucket.www.id
    origin_access_control_id = aws_cloudfront_origin_access_control.www.id
  }

  # Keep CDN in US and CA instead of global
  price_class = "PriceClass_200"

  aliases = var.stage == "stage" ? ["stage.aiaiproject.org"] : ["aiaiproject.org","www.aiaiproject.org"]

  default_cache_behavior {
    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.www.id

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
  }

  custom_error_response {
    error_code = 403
    response_code = 200
    error_caching_min_ttl = 0
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code = 404
    response_code = 200
    error_caching_min_ttl = 0
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      locations = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    # With Domain Name
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"

    # No Domain Name - comment out acm.tf file as well!
    # cloudfront_default_certificate = true
  }
}