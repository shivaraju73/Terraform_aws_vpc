provider "aws" {
  region = "us-east-1"
}

terraform {
    backend "s3" {
        bucket         = "shiva-terraform-state-7373"
        key            = "statefiles/terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "shiva-terraform-state"
    }
}
