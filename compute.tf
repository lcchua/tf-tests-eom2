
#============ ACI FILTER - DYNAMIC IMAGE SELECTION =============
data "aws_ami" "lcchua-tf-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "description"
    values = ["*Amazon Linux 2023 AMI*"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023.5.20240722.0-kernel-6.1-x86_64"]
  }
# To comment out in case the AMI image id changes over time by AWS
/*
  filter {
    name   = "image-id"
    values = ["ami-0427090fd1714168b"]
  }
*/
}
output "ami" {
  description = "stw ami"
  value       = data.aws_ami.lcchua-tf-ami.id
}

#============ EC2 INSTANCE CREATION WITH AUTO-INSTALLATION =============
resource "aws_instance" "lcchua-tf-ec2" {
  count = var.settings.web_app.count  # adjust the number of EC2 instances to create

  ami           = data.aws_ami.lcchua-tf-ami.id
  #instance_type = var.instance_type
  instance_type = var.settings.web_app.instance_type

  key_name = var.key_name
  # To create an EC2 key pair using Terraform, and also 
  # download the key pair to your local machine for you to 
  # use to connect to the EC2 instance
  #key_name      = aws_key_pair.lcchua-tf-key-pair.key_name

  # Uncomment the appropriate subnet_id value assignment as accordingly
  #subnet_id                   = element(aws_subnet.lcchua-tf-public-subnet[*].id, 0)
  subnet_id                   = aws_subnet.lcchua-tf-public-subnet[count.index % length(aws_subnet.lcchua-tf-public-subnet[*].id)]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.lcchua-tf-ec2-web-sg.id]

  # To update the previously created EC2 with a user data script passed in.
  # This is to convert your EC2 into a HTTPD web server.
  user_data_replace_on_change = true    // to trigger a destroy and recreate
  user_data = file("${path.module}/ws_install.sh")

  # Enable detailed monitoring
  monitoring                  = true

  tags = {
    Name  = "${var.stack_name}-ec2-server"
  }
}
output "ec2" {
  description = "stw EC2 instance"
  value       = aws_instance.lcchua-tf-ec2.id
}
output "user-data" {
  description = "stw user data"
  value       = "${path.module}/ws_install.sh"
}
output "ec2_web_public_dns" {
  description = "The public dbs address of the ec2 web app"
  value       = aws_eip.lcchua-tf-eip[0].public_dns

  # Waist for the EIPs to be created and dsitributed
  depends_on = [aws_eip.lcchua-tf-eip]
}