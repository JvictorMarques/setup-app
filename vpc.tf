resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "app-vpc"
  }
}

resource "aws_subnet" "app_subnet_public" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "app-subnet-public"
  }
}

resource "aws_subnet" "app_subnet_private" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "app-subnet-private"
  }
}
resource "aws_internet_gateway" "app_internet_gateway" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "app-internet-gateway"
  }
}

resource "aws_eip" "app_nat_eip" {
  depends_on = [
    aws_internet_gateway.app_internet_gateway
  ]
  tags = {
    Name = "app-nat-eip"
  }
}

resource "aws_nat_gateway" "app_nat_gateway" {
  allocation_id = aws_eip.app_nat_eip.id
  subnet_id     = aws_subnet.app_subnet_public.id

  tags = {
    Name = "app-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.app_internet_gateway
  ]
}

resource "aws_route_table" "app_rt_public" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_internet_gateway.id
  }

  tags = {
    Name = "app-rt-public"
  }
}

resource "aws_route_table_association" "app_rt_public_association" {
  subnet_id      = aws_subnet.app_subnet_public.id
  route_table_id = aws_route_table.app_rt_public.id
}

resource "aws_route_table" "app_rt_private" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.app_nat_gateway.id
  }

  tags = {
    Name = "app-rt-private"
  }
}

resource "aws_route_table_association" "app_rt_private_association" {
  subnet_id      = aws_subnet.app_subnet_private.id
  route_table_id = aws_route_table.app_rt_private.id
}
