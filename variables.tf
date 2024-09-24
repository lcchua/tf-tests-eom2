variable "stack_name" {
  type    = string
  default = "lcchua-stw"
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

/* Uncomment as needed
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}
*/

variable "subnet_count" {
  description = "Number of subnets"
  type        = map(number)
  default = {
    public  = 3,
    private = 3
  }
}

variable "settings" {
  description = "Configuration settings for EC2 and RDS instances"
  type        = map(any)
  default = {
    "database" = {
      allocate_storage  = 10                  // storage in GB
      engine            = "mysql"             // engine type
      engine_version    = "8.0"               // engine_version
      instance_class    = "db.t4g.micro"      // rds instance type
      #db_name           = "eom2_tutorial"    // dtabase name if needed
      skip_final_snapshot = true
    },
    "web_app" = {
      count         = 1           // number of ec2 instances
      instance_type = "t2.micro"  // ec2 instance type
    }
  }
}

# This varaible contains your IP address. 
# This is used when setting up the SSH rule on the web security group.
/* Uncomment as and when needed
variable "my_ip" {
  description = "Your IP address"
  type        = string
  sensitive   = true
}
*/

# This varaible conatins the database master username.
# This will be stored in a secrets file.
variable "db_username" {
  description = "Database master username"
  type        = string
  sensitive   = true
}

# This variable conatins the database master password.
# This will be stored in a secrets file.
variable "db_password" {
  description = "Database master user password"
  type        = string
  sensitive   = true
}

variable "env" {
  description = "Environment of the build"
  type = string
}

variable "rnd_id" {
  description = "Random identifier"
  type = string
}
