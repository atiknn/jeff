module "vpc" {
    source = "../modules/vpc"

    environment_code = var.environment_code
        
}