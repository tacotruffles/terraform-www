data "aws_route53_zone" "zone" {
  # provider = aws.use_default_region
  name = "aiaiproject.org"
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  # provider = aws.use_default_region
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name      = each.value.name
  records   = [each.value.record]
  type      = each.value.type
  zone_id   = data.aws_route53_zone.zone.zone_id
  ttl       = 60
}

resource "aws_route53_record" "stage" {
  count = var.stage == "stage" ? 1 : 0
  zone_id = data.aws_route53_zone.zone.id
  name = "stage.aiaiproject.org"
  type = "A"

  alias {
    name    = aws_cloudfront_distribution.www.domain_name
    zone_id = aws_cloudfront_distribution.www.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex" {
  count = var.stage == "prod" ? 1 : 0
  zone_id = data.aws_route53_zone.zone.id
  name = "aiaiproject.org"
  type = "A"

  alias {
    name = aws_cloudfront_distribution.www.domain_name
    zone_id = aws_cloudfront_distribution.www.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  count = var.stage == "prod" ? 1 : 0
  zone_id = data.aws_route53_zone.zone.id
  name = "www.aiaiproject.org"
  type = "A"

  alias {
    name = aws_cloudfront_distribution.www.domain_name
    zone_id = aws_cloudfront_distribution.www.hosted_zone_id
    evaluate_target_health = false
  }
}