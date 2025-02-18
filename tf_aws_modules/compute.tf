module "lcchua-ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = var.ec2_name

  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = true
  vpc_security_group_ids = [module.lcchua-http-https-ssh-mysql-sg.security_group_id]
  subnet_id              = module.lcchua-vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
output "lcchua-ec2-instance" {
  value = module.lcchua-ec2-instance.id
}
