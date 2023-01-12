provider "aws" {
     region  = "us-east-1"
     access_key = "XXXX"
     secret_key = "XXXX"     
}

terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
      }
    }

    required_version = ">= 1.2.0"
}





