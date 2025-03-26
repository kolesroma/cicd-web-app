provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_security_group" "Ec2SecurityGroup" {
  name        = "Ec2SecurityGroup"
  description = "Allow inbound traffic to EC2 instance"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Ec2MainApplication" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  key_name      = "ec2admin"
  security_groups = [aws_security_group.Ec2SecurityGroup.name]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    sudo apt-get update -y
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io

    sudo usermod -aG docker ubuntu
    sudo systemctl enable docker
    sudo systemctl start docker

    git clone https://github.com/kolesroma/cicd-web-app
    cd cicd-web-app/

    sudo docker build -t my-app .
    sudo docker run -d -p 80:80 --name my-running-app my-app
  EOF

  tags = {
    Name = "Ec2MainApplication"
  }
}

