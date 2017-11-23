terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket  = "nomansland"
      key     = "global/s3/terraform.tfstate"
      region  = "us-east-1"
      encrypt = true
      dynamodb_table = "terragrunt-lock-table"
    }
  }
}

