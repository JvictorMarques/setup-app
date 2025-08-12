data "aws_key_pair" "ssh_key" {
  key_name = "estudo"
}

resource "aws_instance" "web_ec2" {
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.app_subnet_public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.app_pub_sg.id]
  key_name                    = data.aws_key_pair.ssh_key.key_name
  user_data                   = file("docker.sh")

  tags = {
    Name = "web_ec2"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/estudo.pem")
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "~/.ssh/estudo.pem"
    destination = "/home/ubuntu/.ssh/estudo.pem"
  }
}

resource "aws_instance" "db_ec2" {
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.app_subnet_private.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.app_pv_sg.id]
  key_name                    = data.aws_key_pair.ssh_key.key_name
  user_data                   = file("docker.sh")

  tags = {
    Name = "db_ec2"
  }
}
