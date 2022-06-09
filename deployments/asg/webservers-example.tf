provider "aws" {
  region  = "ap-southeast-2"
  version = "3.74.0"
}

module "asg-webservers" {
  source = "../../terraform-modules/asg-webservers"
  vpc_id       = "VPC_ID"
  cluster_name = "asg-main"
  scope        = 3
  subnet_id    = ["Subnet_1", "Subnet_2", "Subnet_3"]
  personal_ip  = "IP_Address" #only enter the ip, not the cidr range
  key_name     = "Key_Name"
}
