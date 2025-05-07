# Creat S3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
} 

# change ownership of bucket to the user
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Make bucket public

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Add ACL (Access Control Policy)
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id #which bucket to upload to
  key    = "index.html" # name it will have in the bucket
  source = "index.html" # local file to upload
  acl = "public-read"   # make it public
  content_type = "text/html"  # tell browser it's HTML  
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}


resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mybucket.id
  key = "profile_pic.png"
  source= "profile_pic.png"
  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.example ]

}
