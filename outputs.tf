output "web_ip" {
  value = aws_instance.web_ec2.public_ip
}

output "db_ip" {
  value = aws_instance.db_ec2.private_ip
}
