terraform {
  backend "s3" {

    bucket       = "tf-state-451664151915-ap-south-1-an"
    key          = "aws/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}

