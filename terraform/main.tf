terraform {

    required_providers{
        aws = {
            source ="hashicorp/aws"
            version ="~> 3.27"
        }
    }
    required_version = ">=1.2"
}

    provider "aws" {
         region ="us-east-1"
    }
    
# Data source for AMI id    
    data "aws_ami" "latest_amazon_linux" {
    owners      = ["amazon"]
    most_recent = true
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

    
# Create an EC2 instance in a default VPC
    resource "aws_instance" "webapp" {
        ami                         = data.aws_ami.latest_amazon_linux.id
        instance_type               = var.instance_type
        key_name                    = aws_key_pair.webapp_kp.key_name
        subnet_id                   = data.aws_subnets.subnet.ids[0]
        associate_public_ip_address = true
        security_groups             = [aws_security_group.webapp_sg.id]
        user_data                   = file("${path.module}/install_docker.sh")
        iam_instance_profile        = "LabInstanceProfile"
        tags = merge(var.default_tags,
             {
                "Name" = "${var.prefix}-webapp-server"
            }
            )
    }
    
    
# Adding SSH key to Amazon EC2
resource "aws_key_pair" "webapp_kp" {
  key_name   = "webapp_kp"
  public_key = file ("path.module}/../webappkp.pub") 
}
    

# Create ECR repositoy for webapp image
     resource "aws_ecr_repository" "webapp-image" {
     name = "clo835-webapp-image"
     
}
 
 
# Create ECR repository for mysql image
     resource "aws_ecr_repository" "sql-image" {
     name = "clo835-mysql-image"
     
}
 



#----------------------------------------------------------
# Data block to retrieve the default VPC and Subnet id
#----------------------------------------------------------


data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}


data "aws_subnets" "subnet" {
  #vpc_id = data.aws_vpc.default.id
}
