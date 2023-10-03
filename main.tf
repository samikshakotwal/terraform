terraform {
  required_providers {
    mycloud = {
      source  = "mycorp/mycloud"
      version = "~> 1.0"
    }
  }
}
provider "aws" {
  access_key="var.accesskey"
  secret_key= "var.secretkey"
  region     = "ap-south-1"
}
resource "aws_key_pair" "tf-key-pair" {
key_name = "tf-key-pair"
public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}
resource "local_file" "tf-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "tf-key-pair"
}
module "vpc"{
source= "./vpcmodule/"
}
module "web" {
source= "./webmodule/"
subnet_id=module.vpc.websubnet_id
vpc_id=module.vpc.vpcid
}
module "app"{
source= "./appmodule/"
subnet_id=module.vpc.appsubnet_id
vpc_id=module.vpc.vpcid
}
module "db"{
source= "./dbmodule/"
vpc_id= module.vpc.vpcid
subnet_id= module.vpc.dbsubnet_id
appsubnetid= module.vpc.appsubnet_id
}

