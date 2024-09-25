terraform {
  backend "s3" {
    bucket = "sctp-ce7-tfstate"
    key    = "${var.stack_name}-${var.env}-${var.rnd_id}.tfstate"
    region = "us-east-1"
  }
}
