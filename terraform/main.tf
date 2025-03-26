provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "Ec2MainApplication" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  key_name      = "ec2admin"
  security_groups = [aws_security_group.Ec2SecurityGroup.name]
  
  tags = {
    Name = "Ec2MainApplication"
  }
}

