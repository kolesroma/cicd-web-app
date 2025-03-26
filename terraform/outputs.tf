output "ec2_public_ip" {
  value = aws_instance.Ec2MainApplication.public_ip
}

