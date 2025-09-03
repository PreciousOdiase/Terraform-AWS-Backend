# AWS Region

variable "aws_region" {
  description = "Variable for AWS Region"
  default     = "us-east-1"
  type        = string

}

# Bucket name

variable "state_bucket" {
  description = "Variable for S3 state file bucket"
  default     = "state-bucket-8932"
}

# DynamoDB table name

variable "state_dynamodb" {
  description = "Variable for DynamoDB state file lock"
  default     = "state-dynamo"
}

# State file key path
variable "state_path" {
  description = "Variable for the path to state file"
  default     = "production/state"
}
