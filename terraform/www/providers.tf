terraform {
  
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
      # configuration_aliases = [ aws.use_default_region ]
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }

  backend "s3" {
    bucket = "${var.tf_state_bucket}" # variables can't be used here.
    key = "${var.tf_state_key}"
    region = "${var.aws_region}" # variables can't be used here.
    profile = "${var.aws_profile}" # variables can't be used here.
  }

  # backend "s3" {
  #   bucket = "" # variables can't be used here.
  #   key = ""
  #   region = "" # variables can't be used here.
  #   profile = "" # variables can't be used here.
  # }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

# provider "aws" {
#   region = var.aws_region
#   profile = var.aws_profile
#   alias = "use_default_region"
# }