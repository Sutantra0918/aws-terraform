output "reports_bucket" {
  description = "S3 bucket for reports"
  value       = aws_s3_bucket.main.id
}

output "audit_bucket_name" {
  description = "S3 bucket for audit logs"
  value       = aws_s3_bucket.audit_logs.id
}

output "cloudtrail_name" {
  description = "CloudTrail name"
  value       = aws_cloudtrail.s3_audit.name
}

output "s3_bucket_reader_policy_arn" {
  description = "ARN of the S3 bucket reader policy"
  value       = aws_iam_policy.s3_bucket_reader_policy.arn
}