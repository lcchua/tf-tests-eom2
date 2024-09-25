terraform {
  backend "s3" {
    bucket = "sctp-ce7-tfstate"
    key    = "tf-lcchua-eom2-25092024.tfstate"
    region = "us-east-1"
  }
}
