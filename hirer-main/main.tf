resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-sfhkhsdfjo34ws"

  tags = {
    Name        = "My bucket"
    Environment = "TEST"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}
