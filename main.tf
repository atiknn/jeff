provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  
  backend "s3" {
    bucket = "terraformstatebucket"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraformstate"
  }

  required_version = ">= 1.2.0"
}
