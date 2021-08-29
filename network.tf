provider "aws" {
  region     = var.AWS_REGION

}

resource "aws_vpc" "Geniusee_EKS" {
  cidr_block           = var.vpc_cidr

  tags = {
    Name = "ES"

  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Geniusee_EKS.id
}

resource "aws_route_table" "IGW" {
  vpc_id = aws_vpc.Geniusee_EKS.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "For_IGW"
  }
}

resource "aws_main_route_table_association" "IGW" {
  vpc_id         = aws_vpc.Geniusee_EKS.id
  route_table_id = aws_route_table.IGW.id
}



resource "aws_subnet" "public" {
  cidr_block              = "10.10.10.0/27"
  vpc_id                  = aws_vpc.Geniusee_EKS.id
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = var.enabled
  tags = {
    Name = "public_1a"
  }
}

resource "aws_subnet" "public1" {
  cidr_block              = "10.10.10.32/27"
  vpc_id                  = aws_vpc.Geniusee_EKS.id
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = var.enabled
  tags = {
    Name = "public_1b"
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "security group for bastion"
  vpc_id      = aws_vpc.Geniusee_EKS.id


  ingress {
    description = "SSH_Connect_to_Bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_my_pool]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "es_cluster_sg" {
  name        = "es-cluster-sg"
  description = "Allow inbound traffic to ElasticSearch from VPC CIDR"
  vpc_id      = aws_vpc.Geniusee_EKS.id
  tags = {
    Name = "es_cluster_sg"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
    #cidr_blocks = [aws_vpc.Geniusee_EKS.cidr_block]
  }

}

data "aws_caller_identity" "current" {}

resource "aws_instance" "For_forward_to_es" {
  ami             = "ami-05f7491af5eef733a"
  instance_type   = var.ins_type
  subnet_id       = aws_subnet.public.id
  security_groups = [aws_security_group.bastion.id]
  key_name        = var.key_name

  tags = {
    Name = "Bastion"
  }
}