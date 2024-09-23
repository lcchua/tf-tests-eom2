terraform {
  backend "s3" {
    bucket = "sctp-ce7-tfstate"
    key    = "tf-lcchua-stw-23092024.tfstate"
    region = "us-east-1"
  }
}

