#terraform import aws_s3_bucket.ResumeBucket cloudresume001

resource "aws_s3_bucket" "ResumeBucket" {
  tags = {
    "name" = "cloud-resume-project"
  }
}
#required to import all attributes
resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.ResumeBucket.id
}