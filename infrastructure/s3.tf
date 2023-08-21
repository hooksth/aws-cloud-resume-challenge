#Frontend Bucket
resource "aws_s3_bucket" "ResumeBucket" {
  tags = {
    "name" = "cloud-resume-project"
    "infra" = "front-end"
  }
}
#required to import all attributes
resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.ResumeBucket.id
}

#Backend Bucket
terraform {
  backend "s3"{
    region = "us-east-1"
    dynamodb_table = "tf-state-lock"
    bucket = "terraform-state-tavaris"
    key = "global/s3/terraforrm.tfstate"
    encrypt = true
  }
}

resource "aws_s3_bucket" "infrastructure" {
  bucket = "terraform-state-tavaris"

  lifecycle {
    prevent_destroy = true

  }

  versioning {
    enabled  = false

  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    "name" = "infrastructure"
    "infra" = "back-end"
  }
}

