provider "aws" {
     region  = "us-east-1"
     access_key = "XX"
     secret_key = "XX"     
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





