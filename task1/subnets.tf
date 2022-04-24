#>>>>create 2 public subnets <<<<

resource "aws_subnet" "publicSubnet1" {
  vpc_id = aws_vpc.myVpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"
  map_public_ip_on_launch = true 
  #anytime we launch an EC2 instance into this subnet this instance will be assigned a public Ipv4 address 
  tags = {
    "Name" = var.public_subnet_1_name
  }
}

resource "aws_subnet" "publicSubnet2" {
  vpc_id = aws_vpc.myVpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone ="ap-southeast-2b"
  map_public_ip_on_launch = true 
  tags = {
    "Name" = var.public_subnet_2_name
  }
}
#>>>>create 2 private subnets <<<<

resource "aws_subnet" "privateSubnet1" {
  vpc_id = aws_vpc.myVpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-southeast-2a"
  map_public_ip_on_launch = false 
  tags = {
    "Name" = var.private_subnet_1_name
  }
}

resource "aws_subnet" "privateSubnet2" {
  vpc_id = aws_vpc.myVpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-southeast-2b"
  map_public_ip_on_launch = false 
  tags = {
    "Name" = var.private_subnet_2_name
  }
}
#>>>>create a elastic ip<<<<

resource "aws_eip" "eip1" {
  vpc      = true
}

resource "aws_eip" "eip2" {
  vpc      = true
}

#>>>>create a nat gateway<<<<
resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.eip1.id
  subnet_id = aws_subnet.publicSubnet1.id

  tags = {
    Name = "nat_gw1"
  }
}

resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.eip2.id
  subnet_id = aws_subnet.publicSubnet2.id

  tags = {
    Name = "nat_gw2"
  }
}

#>>>>create a routing table<<<<

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internetGateway.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table" "private_rt1" {
  vpc_id = aws_vpc.myVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_1.id
  }

  tags = {
    Name = "private_rt1"
  }
}

resource "aws_route_table" "private_rt2" {
  vpc_id = aws_vpc.myVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_2.id
  }

  tags = {
    Name = "private_rt2"
  }
}

#>>>>Provides a resource to create an association between a route table and a subnet<<<<

resource "aws_route_table_association" "rt_for_public_1" {
  subnet_id      = aws_subnet.publicSubnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rt_for_public_2" {
  subnet_id      = aws_subnet.publicSubnet2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rt_for_private_1" {
  subnet_id      = aws_subnet.privateSubnet1.id
  route_table_id = aws_route_table.private_rt1.id
}

resource "aws_route_table_association" "rt_for_private_2" {
  subnet_id      = aws_subnet.privateSubnet2.id
  route_table_id = aws_route_table.private_rt2.id
}
