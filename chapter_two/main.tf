provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "nomansland"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
}

terraform {
  backend "s3" {
    bucket  = "nomansland"
    key     = "global/s3/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

output "s3_bucket_arn" {
  value = "${aws_s3_bucket.terraform_state.arn}"
}
