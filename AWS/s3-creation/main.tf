/* Initializing provider using access keys. Never specify your access keys in code. Use a key management service, environment variables or a managed identity. Will be depicted in future snippets */

provider aws {
    region = "us-east-1"
    access_key = "Access_Key_Id"
    secret_key = "Secret_Access_Key"
}

# Creating a minimal S3 bucket
resource aws_s3_bucket "terraform-bucket" {
    bucket = "zaygo-terraform-bucket" # name must be unique
    acl = "private"
    # Tags
    tags = {
        "Created By" = "Terraform"
    }
    # Versioning
    versioning {
        enabled = true
    }
}