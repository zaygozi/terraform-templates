# Variables to be injected in main.tf file

# AWS Auth
variable "aki" {
    default = "Access_Key_Id"
}
variable "sak" {
    default = "Secret_Access_Key"
}

# Region
variable "region" {
    default = "us-east-1"
}

# Public key for EC2 instance
variable "public_key" {
    default = "Rsa_Public_Key"
}