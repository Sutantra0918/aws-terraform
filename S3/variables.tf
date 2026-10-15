variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "The AWS profile to use for authentication"
  type        = string
  default     = "aws-s3-terraform"
}

