# Terraform AWS Remote Backend Bootstrap

This Terraform project bootstraps a **remote backend** on AWS for managing Terraform state using:

- **Amazon S3** – Remote storage for the `.tfstate` file
- **AWS DynamoDB** – Locking to prevent concurrent operations

It’s designed to be the **first thing you run** when setting up infrastructure-as-code in AWS using Terraform.

---

## 📦 Features

- S3 bucket with:
  - Server-side encryption (AES256)
  - Versioning enabled
- DynamoDB table with:
  - Locking support for Terraform remote state
  - PAY_PER_REQUEST billing mode
- Terraform backend configuration using [Terraform v1.8+ syntax](https://developer.hashicorp.com/terraform/language/settings/backends/s3#lock_table)

---

## 📋 Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) `v1.8.0` or later
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured (`aws configure`)
- AWS IAM user or role with permissions to manage:
  - S3
  - DynamoDB

---

## 🚀 Usage

### 1. Clone the repo

```bash
git clone git@github.com:PreciousOdiase/Terraform-AWS-Backend.git
cd Terraform-AWS-Backend
```

### 2. Customize variables (optional)

Edit variables.tf to set:

- state_bucket – name of the S3 bucket

- state_dynamodb – name of the DynamoDB table

- aws_region – AWS region to deploy to

- state_path – state file key (e.g. production/terraform.tfstate)

### 3. Initialize and apply (local backend)

Before running the following commands, comment or remove the **backend "s3"{}** block in the terraform.tf file. Then run the following commands:

```
terraform init
terraform apply
```

This creates the S3 bucket and DynamoDB table.

### 4. Configure remote backend

After apply, update the terraform.tf file to enable the remote backend (using hardcoded values):

```
terraform {
  backend "s3" {
    bucket          = "your-bucket-name"
    key             = "your/key/path.tfstate"
    region          = "your-region"
    use_lock_table  = true
    lock_table      = "your-lock-table"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.11.0"
    }
  }
}
```

Then run:

```
terraform init
```

Terraform will prompt you to migrate state from local to remote — confirm with yes.

### 📁 Project Structure

|     File     | Purpose                                        |
| :----------: | ---------------------------------------------- |
| variables.tf | Input variables for region, bucket, etc.       |
| terraform.tf | Backend and provider configuration             |
|   state.tf   | AWS resources: S3 bucket and DynamoDB table    |
|   main.tf    | Reserved for future infrastructure definitions |

### 🔐 Security Best Practices

- Enable encryption at rest on the S3 bucket (already enabled with AES256)

- Enable bucket versioning for state history and rollback

- Use least privilege IAM policies to restrict access to:

  - The S3 bucket (s3:GetObject, s3:PutObject, etc.)

  - The DynamoDB table (dynamodb:GetItem, PutItem, etc.)

- Consider using AWS KMS instead of AES256 for encryption (optional)

- Avoid **force_destroy = true** in production environments

### ✅ Recommendations

Use a Separate Project for Backend Bootstrap

This project should be treated as a standalone module or repo. Once the backend is created and initialized:

- Do not include these resources (S3/DynamoDB) in your main infrastructure code

- Avoid managing backend resources from the same stack that uses them

### 🧪 Verification

To verify backend locking is working:

1. Open two terminals in the same directory

2. In terminal 1, run: terraform apply

3. In terminal 2 (while the first is running), run: terraform plan

You should see a lock error in terminal 2, proving that the backend.
