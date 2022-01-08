output "ec2_instance_ip" {
  value = aws_eip.ec2_instance_ip.public_ip
}
