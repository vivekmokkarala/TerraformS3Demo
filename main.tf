provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "website" {
  bucket        = "ramevi"
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
       "Action": [
          "s3:GetObject",
          "s3:PutObject"
       ]
        Resource  = "arn:aws:s3:::ramevi/*"
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.bucket
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
}