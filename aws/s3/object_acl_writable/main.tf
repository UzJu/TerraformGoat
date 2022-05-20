provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "CreateBucket" {
  force_destroy = true
  bucket        = "hxseclab${random_string.random_suffix.result}"

  tags = {
    Name        = "HxCloudLab"
    Environment = "Lab"
  }
}

resource "aws_s3_bucket_acl" "CreateBucketAcl" {
  bucket = aws_s3_bucket.CreateBucket.id
  acl    = "public-read-write"
}

resource "aws_s3_bucket_policy" "CreateBucketPolicy" {
  bucket = aws_s3_bucket.CreateBucket.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "HuoXian",
    "Statement": [
        {
            "Sid": "SecurityLab",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObjectAcl",
                "s3:PutObjectAcl"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.CreateBucket.id}/*"
        }
    ]
}
EOF
}

resource "aws_s3_object" "PutObject" {
  bucket = aws_s3_bucket.CreateBucket.id
  key    = "flag.txt"
  source = "./flag.txt"
}

resource "random_string" "random_suffix" {
  length  = 5
  special = false
  upper   = false
}
