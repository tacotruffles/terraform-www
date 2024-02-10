# Serve Up a static website via an S3 Bucket
resource "random_pet" "petname" {
  length    = 4
  separator = "-"
}

resource "aws_s3_bucket" "www" {
  bucket = "${local.name.prefix}-${random_pet.petname.id}"

  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_website_configuration" "www" {
  bucket = aws_s3_bucket.www.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html" # let react handle all errors
  }
}

resource "aws_s3_bucket_public_access_block" "www" {
  bucket = aws_s3_bucket.www.id

  # All should be set to true when using cloudfront
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "www" {
  bucket = aws_s3_bucket.www.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "www" {
  depends_on = [
	aws_s3_bucket_public_access_block.www,
	aws_s3_bucket_ownership_controls.www,
  ]

  bucket = aws_s3_bucket.www.id

  acl = "private" #"public-read"
}

resource "aws_s3_bucket_policy" "www" {
  depends_on = [
	aws_s3_bucket_public_access_block.www,
	aws_s3_bucket_ownership_controls.www,
  ]

  bucket = aws_s3_bucket.www.id
  policy = templatefile("${path.module}/policies/s3-cloudfront-policy.json", { bucket-arn = aws_s3_bucket.www.arn, cloudfront-arn = aws_cloudfront_distribution.www.arn })
}

# resource "aws_s3_bucket_policy" "www" {
#   bucket = aws_s3_bucket.www.id
#   policy = data.aws_iam_policy_document.www.json
# }

# Directory Upload 
locals {
  www_asset_filepath = "${path.module}/../../www/dist"
}

module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = "${local.www_asset_filepath}"

  # Pass in any values that you wish to use in your templates.
  template_vars = {
    api_url = "${data.terraform_remote_state.api.outputs.api_base_url}"
    stage = "${var.stage}"
    bleep = "bloop"
  }
}

resource "aws_s3_object" "www" {
  depends_on = [
	aws_s3_bucket_public_access_block.www,
	aws_s3_bucket_ownership_controls.www,
  aws_s3_bucket_policy.www
  ]

  acl          = "private"
  bucket       = aws_s3_bucket.www.id
  for_each = module.template_files.files
  key    = each.key
  source = each.value.source_path
  # Use template renders - instead. 
  # Commment out "content" to send un-rendered files only
  content = each.value.content
  content_type = each.value.content_type
  # etag = each.value.digests.md5
  source_hash = each.value.digests.md5 # Better for large file transfers
}
