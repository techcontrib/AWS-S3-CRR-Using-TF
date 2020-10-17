/*  steps involved
a. Setup source bucket in ap-south-1, versioning and encryption (SSE-S3) enabled
b. Setup destination bucket in ap-southeast-1, versioning and encryption (SSE-S3) enabled
c. Create Cross Region Replication (CRR)
    - Create a new IAM role.
    - Replication rule: Entire Bucket
    - Choose destination bucket (bucket in same account)
    - Create a replication policy and attach the policy to created role.
d. Test the setup by uploading the data and check if replication working as expected.
*/

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

resource "aws_iam_role" "replication_role" {
  name = var.iam_role_name

  assume_role_policy = <<POLICY
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Principal":{
            "Service":"s3.amazonaws.com"
         },
         "Action":"sts:AssumeRole"
      }
   ]
}
POLICY
}

resource "aws_iam_policy" "replication_policy" {
  name = var.iam_role_policy_name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.src_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.src_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.dst_bucket.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication_role.name
  policy_arn = aws_iam_policy.replication_policy.arn
}

resource "aws_s3_bucket" "dst_bucket" {
  provider      = aws.singapore
  bucket        = "${var.destination_bucket_name}-${random_integer.rand.result}"
  acl           = var.access
  force_destroy = var.force_destroy
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = var.versioning
  }

}

resource "aws_s3_bucket" "src_bucket" {
  bucket        = "${var.source_bucket_name}-${random_integer.rand.result}"
  acl           = var.access
  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = var.versioning
  }

  replication_configuration {
    role = aws_iam_role.replication_role.arn
    rules {
      id     = "destination"
      prefix = "replication_data/"
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.dst_bucket.arn
        storage_class = "STANDARD_IA"
      }
    }
  }
}

// Upload files to source bucket
resource "aws_s3_bucket_object" "test" {
  for_each = fileset(path.cwd, "replication_data/*")

  bucket = aws_s3_bucket.src_bucket.bucket
  key    = each.value
  source = "${path.cwd}/${each.value}"
}

