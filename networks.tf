
#============ VPC =============
# Note that when a VPC is created, a main route table it created by default
# that is responsible for enabling the flow of network traffic within the VPC

resource "aws_vpc" "lcchua-tf-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    group = var.stack_name
    Name  = "${var.stack_name}-vpc"
  }
}
output "vpc-id" {
  description = "stw vpc"
  value       = aws_vpc.lcchua-tf-vpc.id
}


#============ SUBNETS =============

# Public Subnets
resource "aws_subnet" "lcchua-tf-public-subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.lcchua-tf-vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.stack_name}-public-subnet-${count.index + 1}"
  }
}
output "public-subnet" {
  description = "stw subnet public subnet"
  value       = aws_subnet.lcchua-tf-public-subnet[*].id
}

# Private Subnets
resource "aws_subnet" "lcchua-tf-private-subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.lcchua-tf-vpc.id
  cidr_block              = "10.0.${count.index + 3}.0/24"
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.stack_name}-private-subnet-${count.index + 1}"
  }
}
output "private-subnet" {
  description = "stw subnet private subnet"
  value       = aws_subnet.lcchua-tf-private-subnet[*].id
}


#============ INTERNET GATEWAY =============

resource "aws_internet_gateway" "lcchua-tf-igw" {
  vpc_id = aws_vpc.lcchua-tf-vpc.id

  tags = {
    Name = "${var.stack_name}-igw"
  }
}
output "igw" {
  description = "stw igw"
  value       = aws_internet_gateway.lcchua-tf-igw.id
}


/* Uncomment as and when needed
#============ NAT GATEWAY + EIP =============

resource "aws_nat_gateway" "lcchua-tf-nat-gw" {
  allocation_id = aws_eip.lcchua-tf-eip.id
  subnet_id     = element(aws_subnet.lcchua-tf-public-subnet[*].id, 0)

  tags = {
    Name  = "${var.stack_name}-nat-gw"
  }
}
output "nat-gw" {
  description = "stw NAT gateway"
  value       = aws_nat_gateway.lcchua-tf-nat-gw.id
}

resource "aws_eip" "lcchua-tf-eip" {
  domain = "vpc"
    
  tags = {
    Name  = "${var.stack_name}-eip"
  }
}
output "eip" {
  description = "stw EIP"
  value       = aws_eip.lcchua-tf-eip.id
} 
*/


#============ ROUTE TABLES =============

/* Uncomment as and when needed
# Private subnets route tables and associations
resource "aws_route_table" "lcchua-tf-private-rt" {
  vpc_id = aws_vpc.lcchua-tf-vpc.id

  # since this is exactly the route AWS will create, the route will be adopted
  # this route{} block may not need to be defined here
  route {
    cidr_block = aws_vpc.lcchua-tf-vpc.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.lcchua-tf-nat-gw.id
  }

  tags = {
    Name  = "${var.stack_name}-private-rt"
  }
}
resource "aws_route_table_association" "lcchua-tf-private-rta" {
  count          = length(aws_subnet.lcchua-tf-private-subnet)
  subnet_id      = aws_subnet.lcchua-tf-private-subnet[count.index].id
  route_table_id = aws_route_table.lcchua-tf-private-rt.id
}
output "private-route-table" {
  description = "stw private subnet route table"
  value       = "Private subnet rt = ${aws_route_table.lcchua-tf-private-rt.id}"
}
*/

# Public subnets route tables and associations
resource "aws_route_table" "lcchua-tf-public-rt" {
  vpc_id = aws_vpc.lcchua-tf-vpc.id

  # since this is exactly the route AWS will create, the route will be adopted
  # this route{} block may not need to be defined here
  route {
    cidr_block = aws_vpc.lcchua-tf-vpc.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lcchua-tf-igw.id
  }

  tags = {
    Name = "${var.stack_name}-public-rt"
  }
}
resource "aws_route_table_association" "lcchua-tf-public-rta" {
  count          = length(aws_subnet.lcchua-tf-public-subnet)
  subnet_id      = aws_subnet.lcchua-tf-public-subnet[count.index].id
  route_table_id = aws_route_table.lcchua-tf-public-rt.id
}
output "public-route-table" {
  description = "stw public subnet route table"
  value       = "Public subnet rt = ${aws_route_table.lcchua-tf-public-rt.id}"
}


/* Uncomment as and when needed 
#============ VPC ENDPOINT FOR S3 =============

resource "aws_vpc_endpoint" "lcchua-tf-vpce-s3" {
  vpc_id            = aws_vpc.lcchua-tf-vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    #aws_route_table.lcchua-tf-private-rtb-az1.id,
    #aws_route_table.lcchua-tf-private-rtb-az2.id,
    #aws_route_table.lcchua-tf-private-rtb-az3.id,
    aws_route_table.lcchua-tf-public-rtb.id
  ]

  tags = {
    Name  = "${var.stack_name}-vpc-s3-endpoint"
  }
}
output "vpce-s3" {
  description = "stw vpc endpoint for s3"
  value       = aws_vpc_endpoint.lcchua-tf-vpce-s3.id
}
*/

#============ SECURITY GROUP =============

resource "aws_security_group" "lcchua-tf-sg" {
  name   = "${var.stack_name}-sg"
  vpc_id = aws_vpc.lcchua-tf-vpc.id

  # SSH
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.stack_name}-sg"
  }
}
output "web-sg" {
  description = "stw web security group for ssh http https"
  value       = aws_security_group.lcchua-tf-sg.id
}
