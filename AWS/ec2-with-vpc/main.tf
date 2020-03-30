/* Initializing provider using access keys. Never specify your access keys in code. Use a key management service, environment variables or a managed identity. Will be depicted in future snippets */

provider aws {
    access_key = var.aki 
    secret_key = var.sak
    region = var.region
}

# Creating VPC
resource aws_vpc "terraform-vpc" {
    cidr_block = "10.1.0.0/16"
    # Tags
    tags = {
        "Name" = "Terraform VPC"
        "Created by" = "Terraform"
    }
    # DNS Hostname
    enable_dns_hostnames = true
}

# Creating Subnet 1
resource aws_subnet "terraform-sub-1" {
    vpc_id = aws_vpc.terraform-vpc.id
    cidr_block = "10.1.1.0/24"
    tags = {
        "Name" = "Terraform-Sub-1"
    }
}

# Creating Subnet 2
resource aws_subnet "terraform-sub-2" {
    vpc_id = aws_vpc.terraform-vpc.id
    cidr_block = "10.1.2.0/24"
    tags = {
        "Name" = "Terraform-Sub-2"
    }
}

# Security Group
resource aws_security_group "terraform-sg" {
    name = "terraform-sg"
    description = "Security group for terraform-vpc"
    vpc_id = aws_vpc.terraform-vpc.id
    # Ingress & Egress Rules
    ingress {
        description = "allow ssh access from anywhere"
        from_port = 0
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "allow all egress"
        from_port = 0
        to_port = 0
        protocol = "-1" # all protocols
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Creating a key pair to assign to the instance
resource aws_key_pair "terraform-key" {
    key_name = "terraform-key"
    public_key = var.public_key
}

# Creating Instance Inside Subnet 1
resource aws_instance "terraform-instance" {
    ami = "ami-04ac550b78324f651"
    instance_type = "t3a.micro"
    subnet_id = aws_subnet.terraform-sub-1.id
    # Tags
    tags = {
        "Name" = "Terraform Instance"
    }
    # Root Volume
    root_block_device {
        volume_type = "gp2"
        volume_size = "25"
        delete_on_termination = true
    }
    # Assigning the created key pair to the instance
    key_name = "terraform-key"
}