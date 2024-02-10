# Pull in remote state file for AWS API
data "terraform_remote_state" "api" {
  backend = "s3"
  config = {
    bucket = "${var.tf_state_bucket}" # variables can't be used here?
    key = "${var.prefix}-${var.stage}-api.tf"
    region = var.aws_region
    profile = var.aws_profile
  }
}
