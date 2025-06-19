terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA2V7HC25YMXLBQ447"
  secret_key = "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"
}

resource "aws_vpc" "josue" {
  cidr_block       = "10.0.0.0/25"
  instance_tenancy = "default"

  tags = {
    name = "JOSUE"
  }
}

resource "aws_subnet" "publica" {
  vpc_id     = aws_vpc.josue.id
  cidr_block = "10.0.0.0/26"

  tags = {
    name = "SUBPUBLICA"
  }
}

resource "aws_subnet" "privada" {
  vpc_id     = aws_vpc.josue.id
  cidr_block = "10.0.0.64/26"

  tags = {
    name = "SUBPRIVADA"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.josue.id

  tags = {
    name = "gw-prd"
  }
}


resource "aws_route_table" "rt-publica" {
  vpc_id = aws_vpc.josue.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

}

resource "aws_route_table_association" "public-association" {
  subnet_id      = aws_subnet.publica.id
  route_table_id = aws_route_table.rt-publica.id
}

