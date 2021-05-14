# ---------------------------------------------------------------------------------------------------------------------
# CREATE NETWORK
# ---------------------------------------------------------------------------------------------------------------------

#Create VPC 
resource "aws_vpc" "vpc_Jenkins" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-jenkins"
  }
}

#Create IGW 
resource "aws_internet_gateway" "igw" {
  provider = aws.region-master
  vpc_id = aws_vpc.vpc_Jenkins.id
}

#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state = "available"
}

#Create subnet # 1 
resource "aws_subnet" "subnet_1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_Jenkins.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

#Create route table 
resource "aws_route_table" "internet_route" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_Jenkins.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "Master-Region-RT"
  }
}