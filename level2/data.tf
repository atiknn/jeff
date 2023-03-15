data "terraform_remote_state" "level1" {
  backend = "s3"

  config = {
    bucket = "terraformstatebucket"
    key = "level1.tfstate"
    region = "us-eat-1"
    }
  }
}