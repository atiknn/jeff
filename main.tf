provider "aws" {
     region  = "us-east-1"
     access_key = "AKIAYZ7SDPK4BKDYRAAN"
     secret_key = "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"     
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





