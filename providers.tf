terraform {
  required_version = "= 1.1.2"
  required_providers {
    aws = {
      version = ">= 3.7"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      CreatedBy = "Terraform"
      Owner     = "Your Name"
    }
  }

}
