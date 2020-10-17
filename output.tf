output "fileset-results" {
  value = fileset(path.cwd, "replication_data/*")
}

output "source-bucket-arn" {
  value = aws_s3_bucket.src_bucket.arn
}

output "destination-bucket-arn" {
  value = aws_s3_bucket.dst_bucket.arn
}
