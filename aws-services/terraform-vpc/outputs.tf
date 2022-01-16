output "external_vpc" {
  value = aws_vpc.prod_vpc
}

output "external_subnet" {
  value = aws_subnet.prod_subnet_public_1.id
}

output "ec2_sg" {
  value = aws_security_group.ec2_sg.id
}
