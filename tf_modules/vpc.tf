module "lcchua-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

# Note that enable_dns_support and enable_dns_hostnames are defaulted 
# True in the TF Registry VPC module
//  enable_nat_gateway = true
  enable_vpn_gateway      = true
  map_public_ip_on_launch = true

  tags = {
    Terraform = "true"
    Environment = var.env
    Created_by = "lcchua"
    Cohort = "CE7"
  }
}
output "lcchua-vpc-arn" {
  value = module.lcchua-vpc.vpc_arn
}

module "lcchua-http-https-ssh-mysql-sg" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = var.sg_name
  description = "Security group for http-https-ssh-mysql ports"
  vpc_id      = module.lcchua-vpc.vpc_id

  //ingress_cidr_blocks = ["10.10.0.0/16"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL/Aurora"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]

  tags  = {
    Name        = "lcchua-http-https-ssh-mysql-sg"
    Environment = var.env
  }
}
output "lcchua-http-https-ssh-mysql-sg-id" {
  value = module.lcchua-http-https-ssh-mysql-sg.security_group_id
}
