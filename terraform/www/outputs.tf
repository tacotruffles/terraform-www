# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# output "www_url" {
#   value = "http://${aws_s3_bucket_website_configuration.www.website_endpoint}"
# }

output "api_base_url" {
  value = data.terraform_remote_state.api.outputs.api_base_url
}

output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.www.domain_name}"
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.www.id
}