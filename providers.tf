terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
# provider "aws" {
#   region     = "eu-west-1"
#   access_key = ""
#   secret_key = ""
# }

provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "/Users/rahkat/.aws/credentials"
  profile                 = "lab"
}