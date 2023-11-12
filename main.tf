provider "aws" {
  region = "eu-west-3"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = data.aws_vpc.default.id
  cidr_block = "172.31.48.0/20"
  availability_zone = "eu-west-3a"
}

