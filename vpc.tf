provider "aws" {
  region = "eu-west-3"
}

variable vpc_cidr_block {}
variable private_subnets_cidr_blocks {}
variable public_subnets_cidr_blocks {}

data "aws_availability_zones" "azs" {}

module "voteapp-vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "5.1.2"
    name = "voteapp-vpc"
    cidr = var.vpc_cidr_block
    private_subnets = var.private_subnets_cidr_blocks
    public_subnets = var.public_subnets_cidr_blocks
    azs = data.aws_availability_zones.azs.names

    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true

    tags = {
        "kubernetes.io/cluster/voteapp-eks-cluster" = "shared"
    }

    public_subnet_tags = {
        "kubernetes.io/cluster/voteapp-eks-cluster" = "shared"
        "kubernetes.io/role/elb" = 1
    }

    private_subnet_tags = {
        "kubernetes.io/cluster/voteapp-eks-cluster" = "shared"
        "kubernetes.io/role/internal-elb" = 1
    }

}