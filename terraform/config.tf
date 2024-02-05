terraform {
  backend "s3" {
    bucket = "clo835"  
    key    = "assignment1/terraform.tfstate" 
    region = "us-east-1"
  }
}
