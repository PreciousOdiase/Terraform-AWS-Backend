terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.11.0"
    }
  }
  backend "s3" {
    bucket         = "state-bucket-8932"
    key            = "production/state"
    use_lockfile   = true
    region         = "us-east-1"
    use_lock_table = true
    lock_table     = "state-dynamo"
  }
}
