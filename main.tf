resource "aws_s3_bucket" "newbucket" {
    bucket = "saitama122"
}


resource "aws_s3_bucket_public_access_block" "policychange" {
  bucket = aws_s3_bucket.newbucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

  resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.newbucket.id
  policy = jsonencode(
    {
    Version = "2012-10-17",
    Statement = [
        {
            Sid = "PublicReadGetObject",
            Effect = "Allow",
            Principal = "*",
            Action = "s3:GetObject",
            Resource = "arn:aws:s3:::${aws_s3_bucket.newbucket.id}/*",
        }
    ]
  }
  )
}

resource "aws_s3_bucket_website_configuration" "config" {
  bucket = aws_s3_bucket.newbucket.id

  index_document {
    suffix = "index.html"
  }

  }
resource "aws_s3_object" "index" {
    bucket       = aws_s3_bucket.newbucket.id
    source       = "./index.html"
    key         = "index.html"
    content_type = "text/html"
}

resource "aws_s3_object" "styles" {
    bucket       = aws_s3_bucket.newbucket.id
    source       = "./styles.css"
    key         = "styles.css"
    content_type = "text/css"
}


output "name" {
    value = aws_s3_bucket_website_configuration.config.website_endpoint
}