
#============ VPC =============
# Note that when a VPC is created, a main route table it created by default
# that is responsible for enabling the flow of network traffic within the VPC

resource "aws_vpc" "lcchua-tf-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    group = var.stack_name
    Name  = "stw-vpc"
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
    group = var.stack_name
    Name  = "stw public-subnet-$count_index +1}"
  }
}
output "public-subnet" {
  description = "stw subnet public subnet"
  value       = element(aws_subnet.lcchua-tf-public-subnet[*].id, 0)
}

# Private Subnets
resource "aws_subnet" "lcchua-tf-private-subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.lcchua-tf-vpc.id
  cidr_block              = "10.0.${count.index + 3}.0/24"
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    group = var.stack_name
    Name  = "stw private-subnet-$count_index +1}"
  }
}
output "private-subnet" {
  description = "stw subnet private subnet"
  value       = element(aws_subnet.lcchua-tf-private-subnet[*].id, 0)
}


#============ INTERNET GATEWAY =============

resource "aws_internet_gateway" "lcchua-tf-igw" {
  vpc_id = aws_vpc.lcchua-tf-vpc.id

  tags = {
    group = var.stack_name
    Name  = "stw-igw"
  }
}
output "igw" {
  description = "stw igw"
  value       = aws_internet_gateway.lcchua-tf-igw.id
}


#============ NAT GATEWAY + EIP =============

resource "aws_nat_gateway" "lcchua-tf-nat-gw" {
  allocation_id = aws_eip.lcchua-tf-eip.id
  subnet_id     = element(aws_subnet.lcchua-tf-public-subnet[*].id, 0)

  tags = {
    Name  = "stw-nat-gw"
    group = var.stack_name
  }
}
output "nat-gw" {
  description = "stw NAT gateway"
  value       = aws_nat_gateway.lcchua-tf-nat-gw.id
}

resource "aws_eip" "lcchua-tf-eip" {
    domain = "vpc"
    tags = {
    group = var.stack_name
    Name  = "stw-eip"
  }
}
output "eip" {
  description = "stw EIP"
  value       = aws_eip.lcchua-tf-eip.id
}


#============ ROUTE TABLES =============

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
    group = var.stack_name
    Name  = "stw-private-rt"
  }
}
resource "aws_route_table_association" "lcchua-tf-private-rta" {
  count          = length(aws_subnet.lcchua-tf-private-subnet)
  subnet_id      = aws_subnet.lcchua-tf-private-subnet[count.index].id
  route_table_id = aws_route_table.lcchua-tf-private-rt.id
}
output "private route table" {
  description = "stw private subnet route table"
  value       = "Private subnet rt = ${aws_route_table.lcchua-tf-private-rt.id}, rta = ${aws_route_table_association.lcchua-tf-private-rta.id}"
}

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
    group = var.stack_name
    Name  = "stw-public-rt"
  }
}
resource "aws_route_table_association" "lcchua-tf-public-rta" {
  count          = length(aws_subnet.lcchua-tf-public-subnet)
  subnet_id      = aws_subnet.lcchua-tf-public-subnet[count.index].id
  route_table_id = aws_route_table.lcchua-tf-public-rt.id
}
output "public route table" {
  description = "stw public subnet route table"
  value       = "Public subnet rt = ${aws_route_table.lcchua-tf-public-rt.id}, rta = ${aws_route_table_association.lcchua-tf-public-rta.id}"
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
    group = var.stack_name
    Name  = "stw-vpc-s3-endpoint"
  }
}
output "vpce-s3" {
  description = "stw vpc endpoint for s3"
  value       = aws_vpc_endpoint.lcchua-tf-vpce-s3.id
}
*/

#============ SECURITY GROUP =============

resource "aws_security_group" "lcchua-tf-sg-allow-ssh-http-https" {
  name   = "lcchua-tf-sg-allow-ssh-http-https"
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
    group = var.stack_name
    Name  = "stw-sg-ssh-http-https"
  }
}
output "web-sg" {
  description = "stw web security group for ssh http https"
  value       = aws_security_group.lcchua-tf-sg-allow-ssh-http-https.id
}
