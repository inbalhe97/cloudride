
# Create a VPC
resource "aws_vpc" "myVpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name= var.vpc_name
  }
}

# Create an internet getaway 
resource "aws_internet_gateway" "internetGateway"{
  vpc_id= aws_vpc.myVpc.id
  tags = {
    Name= var.igw_name
  }
}


