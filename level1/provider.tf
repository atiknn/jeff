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
    bucket         = "terraformstatebucketl2"
    key            = "level1.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraformstatedynamo"
  }

  required_version = ">= 1.2.0"
}
