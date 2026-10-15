resource "aws_s3_object" "demo-report" {
  bucket = aws_s3_bucket.main.id

  key    = "documents/demo-report.txt"
  source = "${path.module}/samples/demo-report.txt"

  source_hash = filemd5(
    "${path.module}/samples/demo-report.txt"
  )

  content_type  = "text/plain"
  storage_class = "STANDARD"

  depends_on = [
    aws_s3_bucket_versioning.main,
    aws_s3_bucket_server_side_encryption_configuration.main,
    aws_s3_bucket_policy.https_only
  ]
}

resource "aws_s3_object" "direct_ia_backup" {
  bucket = aws_s3_bucket.main.id

  key    = "direct-ia/backup-demo.bin"
  source = "${path.module}/samples/backup-demo.bin"

  source_hash = filemd5(
    "${path.module}/samples/backup-demo.bin"
  )

  content_type  = "application/octet-stream"
  storage_class = "STANDARD_IA"

  depends_on = [
    aws_s3_bucket_versioning.main,
    aws_s3_bucket_server_side_encryption_configuration.main,
    aws_s3_bucket_policy.https_only
  ]
}