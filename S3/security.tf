
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid     = "DenyInsecureConnections"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.main.arn,
      "${aws_s3_bucket.main.arn}/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    condition {
      test     = "Bool"
      variable = "aws:PrincipalIsAWSService"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "https_only" {
  bucket     = aws_s3_bucket.main.id
  policy     = data.aws_iam_policy_document.s3_bucket_policy.json
  depends_on = [aws_s3_bucket.main, aws_s3_bucket_public_access_block.main]
}

data "aws_iam_policy_document" "s3_bucket_reader_policy" {

  statement {
    sid     = "AllowReadAccessDocument"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.main.arn}/documents/*"
    ]
  }
}

resource "aws_iam_policy" "s3_bucket_reader_policy" {
  name   = "${var.project_name}-s3-bucket-reader-policy"
  policy = data.aws_iam_policy_document.s3_bucket_reader_policy.json
}