terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

#vpc creation#

resource "aws_vpc" "vpc_name" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    owner = var.owner
    Name = var.vpc-name
  }
}

#create IGW#

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_name.id
  tags = {
    owner = var.owner
    Name = var.igw-name
  }
}

###elastic IP address###

resource "aws_eip" "eip-address" {
  domain = "vpc"
  tags = {
    owner = var.owner
  }
}

#public subnet#

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.vpc_name.id
  cidr_block              = var.public-subnet-cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = {
    owner = var.owner
    Name  = var.public-subnet-name
  }
}

#public route table#

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc_name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    owner = var.owner
    Name = "sjh-public-rt-name"
  }
}

resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}
