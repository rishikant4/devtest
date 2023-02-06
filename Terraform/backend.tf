terraform {
  backend "s3" {
    bucket = "rishi-terraform-statefile"
    key = "server_name/statefile"
    region = "us-east-1"
  }
}  
