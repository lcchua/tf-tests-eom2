 variable "stack_name" {
  type    = string
  default = "lcchua-STW"
}

variable "key_name" {
  description = "Name of EC2 Key Pair"
  type        = string
//  default     = "lcchua-useast1-20072024"
  default       = "lcchua-useast1-30072024"
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
