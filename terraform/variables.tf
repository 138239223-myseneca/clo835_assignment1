variable "instance_type" {
  default     = "t3.micro"
  description = "Type of the instance"
  type        = string
}



variable "default_tags" {
  default = {
    "Name"  = "clo835-a1"
    "Owner" = "Rose"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}



variable "prefix" {
  default     = "clo835-a1"
  type        = string
  description = "Name prefix"
}