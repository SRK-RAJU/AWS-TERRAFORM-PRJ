#terraform {
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = "~> 3.27"
#    }
#  }
#  required_version = ">= 0.14.9"
#}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}
#terraform {
#  required_providers {
#    docker = {
#      source  = "kreuzwerker/docker"
#      version = "~> 2.13.0"
#    }
#  }
#}

provider "docker" {}


terraform {
    backend "s3" {
      bucket = "terra-sree1"
      dynamodb_table = "terraform-state-lock-dynamo"
      key    = "raju/terraform.tfstate"
      region = "us-east-1"
    }
  }

provider "aws" {
#  profile = "default" # aws credential in $HOME/.aws/credentials
  region  = "us-east-1"
#  access_key = "xxxxxxxxx"
#  secret_key = "xxxxxxx"
}