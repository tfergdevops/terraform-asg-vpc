provider "aws" {
  region  = "ap-southeast-2"
  version = "3.74.0"
}

module "vpc" {
  source = "../terraform-modules/vpc"

  vpc_name          = "vpc-dev"
  vpc_cidr_block    = "192.168.0.0/16"
  subnet_names      = ["sub-a", "sub-b", "sub-c"]
  subnet_cidr_block = ["10.0.0.1/24", "192.168.1.0/24", "192.168.2.0/24"]
  avail_zone        = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
}