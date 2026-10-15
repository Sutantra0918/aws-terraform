# AWS S3 Infrastructure with Terraform

A hands-on AWS infrastructure project that provisions **secure document storage and centralized S3 activity logging** using Terraform. I deployed the infrastructure in **AWS ap-south-1**, tested object uploads/downloads, and verified that CloudTrail delivered audit logs to a separate S3 bucket.

## Architecture

```text
                      Terraform
                         |
            +------------+------------+
            |                         |
    Documents S3 bucket        Audit Logs S3 bucket
    - Private access           - Private access
    - SSE-S3 encryption        - SSE-S3 encryption
    - Versioning               - Versioning
    - Lifecycle rules                 ^
            |                         |
     S3 object operations ----> AWS CloudTrail
        (Put/Get/Delete)        (S3 data events)

    IAM read-only policy -> documents/* (created, not attached)
```

## What I Implemented

| Area | Implementation |
|---|---|
| **Infrastructure as Code** | Provisioned and configured the S3, IAM, and CloudTrail resources with reusable Terraform configuration. |
| **S3 storage** | Created a private documents bucket with all four S3 Block Public Access settings, `BucketOwnerEnforced` ownership, and default **SSE-S3 (AES256)** encryption. |
| **Secure transport** | Applied a bucket policy that denies non-HTTPS requests from non-service principals. |
| **Versioning & lifecycle** | Enabled versioning; configured the `archive/` prefix to move current objects to **Standard-IA after 30 days**, transition noncurrent versions after **30 days**, and expire noncurrent versions after **90 days**. |
| **Access control** | Created an IAM policy granting `s3:GetObject` on the `documents/*` prefix only. The policy is ready to attach to an authorized identity. |
| **S3 auditing** | Created a separate encrypted, versioned audit bucket and configured **CloudTrail S3 object-level data events** for the documents bucket, with log-file validation enabled. |
| **Storage classes** | Uploaded sample objects using **S3 Standard** and **Standard-IA**. |

## What I Tested

- Ran `terraform validate`, `terraform plan`, and `terraform apply` and deployed the resources to AWS.
- Uploaded and downloaded an object through the AWS CLI and confirmed it was present in the documents bucket.
- Confirmed CloudTrail was logging, its advanced event selector targeted the correct bucket, and **audit log files were delivered** to the audit bucket.
- Troubleshot and fixed real deployment errors involving an invalid IAM policy `Sid`, CloudTrail log-delivery permissions, and a malformed S3 object ARN in the audit bucket policy.

## Tools & Services

**AWS:** Amazon S3, AWS IAM, AWS CloudTrail  
**IaC & validation:** Terraform, AWS CLI, PowerShell, Git

## Project Files

| File | Purpose |
|---|---|
| `main.tf` | AWS provider and main S3 bucket configuration |
| `security.tf` | HTTPS-only bucket policy and IAM read-only policy |
| `lifecycle.tf` | S3 lifecycle rules |
| `objects.tf` | Upload sample objects with different storage classes |
| `audit.tf` | Audit bucket, CloudTrail permissions and trail |
| `variables.tf`, `output.tf` | Inputs and useful Terraform outputs |
| `versions.tf`, `backend.tf` | Terraform version/provider and backend configuration |
| `samples/` | Non-sensitive sample objects |

## Deploy

From the `S3/` directory, configure your AWS CLI credentials and then run:

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
terraform apply
```

Run `terraform output` to see the generated bucket names and trail name. Use `terraform destroy` to remove the lab when finished.

> **Note:** This is a learning/portfolio environment, not a production deployment. The S3 buckets use `force_destroy = true`, which can permanently delete objects and versions during cleanup. S3 storage, requests, CloudTrail data-event logging, and other AWS usage may incur charges.
