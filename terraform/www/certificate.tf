#AMC Certificate resource with domain name, DNS validation, and alternative names
resource "aws_acm_certificate" "cert" {
  domain_name = var.stage == "stage" ? "stage.aiaiproject.org" : "aiaiproject.org"
  validation_method = "DNS"
  subject_alternative_names = var.stage == "stage" ? [] : ["*.aiaiproject.org"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  # provider = aws.use_default_region
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}