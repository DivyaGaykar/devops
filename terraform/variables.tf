variable "region" {
  description = "Region to create infra"
  default = "ap-south-1"
}

variable "vpc_cidr" {
  description = "vpc cidr"
  default = "10.0.0.0/16"
}

variable "pri_sub_cidr" {
  description = "Private subnet cidr"
  default = "10.0.0.0/24"
}

variable "pri_sub_az" {
  description = "Availability zone for private subnet"
  default = "ap-south-1a"
}

variable "pub_sub_cidr" {
  description = "Public subnet cidr"
  default = "10.0.1.0/24"
}

variable "pub_sub_az" {
  description = "Availability zone for public subnet"
  default = "ap-south-1a"
}

variable "instance_ami_id" {
  description = "AMI ID for instance"
  type = map(string)
  default = {
    us-east-1 = "us-ami",
    ap-south-1 = "ami-03f4878755434977f"
  }
}

variable "instance_type" {
  description = "Instance type"
  default = "t2.micro"
}

variable "instance_key_pair" {
  description = "Key pair file to use to launch instance"
  default = "sanket-mumbai"
}
