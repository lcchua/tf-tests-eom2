variable "stack_name" {
  type    = string
  default = "lcchua-STW"
}

variable "key_name" {
  description = "Name of EC2 Key Pair"
  type        = string
  //  default     = "lcchua-useast1-20072024"
  default = "lcchua-useast1-30072024"
}

variable "working_dir" {
  description = "Pathname of my local working directory"
  type        = string
  default     = "/Users/laich/NTU_CE7"
}

variable "region" {
  description = "Name of aws region"
  type        = string
  default     = "us-east-1"
}

# The variables defined from here on are meant for the AWS VPC Terraform module
variable "vpc_name" {
  description = "The VPC Name to use"
  type        = string
  default     = "${var.stack_name}-vpc"
}
variable "sg_name" {
  description = "Security group for http-https-ssh"
  type        = string
  default     = "${var.stack_name}-sg-http-https-ssh"
}

variable "ec2_name" {
  description = "Name of EC2"
  type        = string
  default     = "${var.stack_name}-ec2-instance"
}
