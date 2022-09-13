terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}
terraform {
    backend "s3" {
      bucket = "terra-sree"
      key    = "raju/terraform.tfstate"
      region = "us-east-1"
    }
  }

provider "aws"{
  profile = "default" # aws credential in $HOME/.aws/credentials
  region  = "us-east-1"
  access_key = "xxxxxxxxx"
  secret_key = "xxxxxxx"
}