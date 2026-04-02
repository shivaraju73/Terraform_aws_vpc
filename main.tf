# module "ec2_instance" {
#   source = "./modules/ec2_instance"

#   ami_id              = var.ami_id
#   instance_type_dev   = var.instance_type_dev
#   instance_type_prod  = var.instance_type_prod
#   environment         = var.environment
# }

resource "aws_s3_bucket" "statefile" {
  bucket = "shiva-terraform-state-7373"

  tags = {
    Name = "Terraform State Bucket"
  }
}

resource "aws_dynamodb_table" "statefile" {
  name         = "shiva-terraform-state"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform State Lock Table"
  }
}