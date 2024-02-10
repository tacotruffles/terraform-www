# Generate project-based prefix string for user-friendly asset names
locals {
  name = {
    prefix = "${var.prefix}-${var.stage}"
  }
}

variable "stage" {
  description = "CI/CD pipeline stage"
  type = string
  default = "stage"
}

variable "prefix" {
  description = "Acronym for your project"
  type = string
}
variable "aws_region" {
  description = "AWS region for deployment"
  type = string
}

variable "aws_profile" {
  description = "AWS CLI Profile name"
  type = string
}

variable "tf_state_bucket" {
  description = "Terraform Backend: S3 bucket"
  type = string
}

variable "tf_state_key" {
  description = "Terraform Backend: S3 key"
  type = string
}

# TBD
# variable "tf_state_table" {
#   description = "Terraform Backend: S3 state table"
#   type = string
# }