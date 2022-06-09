# terraform-asg-vpc
I built this as a personal project to learn Terraform and AWS. 

It deploys a virtual private network in AWS and then an auto-scaling group, load balanced web-server running nginx across three regions. 

Everything is utilizing the free tier so nothing here will cost anyone any money, although it's still a good idea to setup an alert to be sure. 

#### Deploy the VPC

Make sure to deploy the VPC first and to set your variables in the vpc-example.tf

``` Json
provider "aws" {
  region  = "ap-southeast-2"
  version = "3.74.0"
}

module "vpc" {
  source = "../../terraform-modules/vpc"

  vpc_name          = "vpc-main"
  vpc_cidr_block    = "192.168.0.0/16"
  subnet_names      = ["sub-a", "sub-b", "sub-c"]
  subnet_cidr_block = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
  avail_zone        = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
}
```

During the deployment, the IDs for the VPC and the Subnets will be displayed in the output, so that's an easy way to grab them and put them into the asg-example.tf

#### Deploy the ASG

You need to get the vpc_id and the subnet_ids to add as variables which should be in the output from deploying the VPC. The only one you may have to login to the web interface for is the key_name. The assumption is you've already created the key to access your AWS environment.

``` JSON
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
```


