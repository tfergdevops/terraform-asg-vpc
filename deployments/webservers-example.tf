provider "aws" {
  region  = "ap-southeast-2"
  version = "3.74.0"
}

module "asg-webservers" {
  source = "../terraform-modules/aws-webservers"
  vpc_id       = "VPC_ID_HERE"
  cluster_name = "asg-dev"
  scope        = 3
  subnet_id    = ["SUBNET_ID_HERE", "SUBNET_ID_HERE", "SUBNET_ID_HERE"]
  personal_ip  = "YOUR_IP_HERE" #only enter the ip, not the cidr range
}
