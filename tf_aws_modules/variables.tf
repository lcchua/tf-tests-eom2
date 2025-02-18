variable "env" {
  description = "The env of the S3 bucket"
  type        = string
  default     = "dev"
}

variable "department" {
  description = "The Department of the S3 bucket owner"
  type        = string
  default     = "DevOps"
}

variable "vpc_name" {
  description = "The VPC Name to use"
  type        = string
  default     = "lcchua-vpc-tf-module"
}

variable "sg_name" {
  description = "Security group for http-https-ssh-mysql"
  type        = string
  default     = "lcchua-sg-http-https-ssh-mysql-tf-module"
}

variable "ec2_name" {
  description = "Name of EC2"
  type        = string
  default     = "lcchua-ec2-instance-tf-module"
}

variable "instance_type" {
  description = "EC2 Instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of EC2 Key Pair"
  type        = string
  default     = "lcchua-useast1-20072024"
}
