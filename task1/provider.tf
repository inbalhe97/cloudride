terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.10.0"
    }
  }
}

provider "aws" {
    region = "ap-southeast-2"
    shared_credentials_files = ["C:\\Users\\inbal\\.aws\\credentials"]
}