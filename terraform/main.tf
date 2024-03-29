terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "test_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "jenkins_vpc"
  }
}

resource "aws_subnet" "test_pub_sub" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = var.pub_sub_cidr
  availability_zone = var.pub_sub_az


  tags = {
    Name = "jenkins_pub_sub"
  }
}

resource "aws_subnet" "test_pri_sub" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = var.pri_sub_cidr
  availability_zone = var.pri_sub_az 

  tags = {
    Name = "jenkins_pri_sub"
  }
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "jenkins_igw"
  }
}

resource "aws_route_table" "test_pub_rt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }

  tags = {
    Name = "jenkins-pub_rt"
  }
}

resource "aws_route_table_association" "pub-association" {
  subnet_id      = aws_subnet.test_pub_sub.id
  route_table_id = aws_route_table.test_pub_rt.id
}

resource "aws_route_table" "test_pri_rt" {
  vpc_id = aws_vpc.test_vpc.id
  
  tags = {
    Name = "jenkins_pri_sub"
  } 
} 

resource "aws_route_table_association" "pri-association" {
  subnet_id      = aws_subnet.test_pri_sub.id
  route_table_id = aws_route_table.test_pri_rt.id
}


resource "aws_security_group" "test_sg" {
  name        = "jenkins_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.test_vpc.id

  tags = {
    Name = "jenkins_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "test_ipv4" {
  security_group_id = aws_security_group.test_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_instance" "test_pub_instance" {
  ami           = "${var.instance_ami_id[var.region]}"
  instance_type = var.instance_type
  key_name = var.instance_key_pair
  subnet_id = aws_subnet.test_pub_sub.id
  associate_public_ip_address = true
  tags = {
    Name = "jenkins_pub_instance"
  }
}

resource "aws_instance" "test_pri_instance" {
  ami           = "${var.instance_ami_id[var.region]}"
  instance_type = var.instance_type
  key_name = var.instance_key_pair
  subnet_id = aws_subnet.test_pri_sub.id

  tags = {
    Name = "jenkins_pri_instance"
  }
}

