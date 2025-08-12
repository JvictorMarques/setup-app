resource "aws_security_group" "app_pub_sg" {
  name        = "app-sg-web"
  description = "Security group for web application instances"
  vpc_id      = aws_vpc.app_vpc.id

  tags = {
    Name = "app-sg-web"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_pub_sg_ssh_ingress" {
  description       = "Permite acesso SSH (porta 22) apenas do IP configurado"
  security_group_id = aws_security_group.app_pub_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.meu_ip
}

resource "aws_vpc_security_group_ingress_rule" "app_pub_sg_http_ingress" {
  description       = "Permite trafego HTTP (porta 80) de qualquer origem"
  security_group_id = aws_security_group.app_pub_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "app_pub_sg_https_ingress" {
  description       = "Permite trafego HTTPS (porta 443) de qualquer origem"
  security_group_id = aws_security_group.app_pub_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "app_pub_sg_ssh_egress" {
  description       = "Permite saida SSH (porta 22) para a VPC"
  security_group_id = aws_security_group.app_pub_sg.id
  to_port           = 22
  from_port         = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = aws_vpc.app_vpc.cidr_block
}

resource "aws_vpc_security_group_egress_rule" "app_pub_sg_http_egress" {
  description       = "Permite trafego de saida HTTP (porta 80) para qualquer destino"
  security_group_id = aws_security_group.app_pub_sg.id
  to_port           = 80
  from_port         = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "app_pub_sg_https_egress" {
  description       = "Permite trafego de saida HTTPS (porta 443) para qualquer destino"
  security_group_id = aws_security_group.app_pub_sg.id
  to_port           = 443
  from_port         = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "app_pub_sg_dns_tcp_egress" {
  description       = "Permite saida DNS TCP (porta 53) para qualquer destino"
  security_group_id = aws_security_group.app_pub_sg.id
  to_port           = 53
  from_port         = 53
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "app_pub_sg_dns_udp_egress" {
  description       = "Permite saida DNS UDP (porta 53) para qualquer destino"
  security_group_id = aws_security_group.app_pub_sg.id
  to_port           = 53
  from_port         = 53
  ip_protocol       = "udp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "app_pub_sg_mongodb_egress" {
  description       = "Permite saida para MongoDB (porta 27017) na VPC"
  security_group_id = aws_security_group.app_pub_sg.id
  to_port           = 27017
  from_port         = 27017
  ip_protocol       = "tcp"
  cidr_ipv4         = aws_vpc.app_vpc.cidr_block
}

resource "aws_network_acl" "app_pub_nacl" {
  vpc_id     = aws_vpc.app_vpc.id
  subnet_ids = [aws_subnet.app_subnet_public.id]
  tags = {
    "Name" = "app-pub-nacl"
  }
}

resource "aws_network_acl_rule" "app_pub_nacl_ssh_ingress" {
  network_acl_id = aws_network_acl.app_pub_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "app_pub_nacl_http_ingress" {
  network_acl_id = aws_network_acl.app_pub_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "app_pub_nacl_https_ingress" {
  network_acl_id = aws_network_acl.app_pub_nacl.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "app_pub_nacl_dns_tcp_ingress" {
  network_acl_id = aws_network_acl.app_pub_nacl.id
  rule_number    = 130
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "app_pub_nacl_dns_udp_ingress" {
  network_acl_id = aws_network_acl.app_pub_nacl.id
  rule_number    = 140
  egress         = false
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "app_pub_nacl_ephemeral_ports_ingress" {
  network_acl_id = aws_network_acl.app_pub_nacl.id
  rule_number    = 199
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "app_pub_nacl_ssh_egress" {
  network_acl_id = aws_network_acl.app_pub_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "app_pub_nacl_http_egress" {
  network_acl_id = aws_network_acl.app_pub_nacl.id
  rule_number    = 210
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "app_pub_nacl_https_egress" {
  network_acl_id = aws_network_acl.app_pub_nacl.id
  rule_number    = 220
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "app_pub_nacl_dns_tcp_egress" {
  network_acl_id = aws_network_acl.app_pub_nacl.id
  rule_number    = 230
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "app_pub_nacl_dns_udp_egress" {
  network_acl_id = aws_network_acl.app_pub_nacl.id
  rule_number    = 240
  egress         = true
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "app_pub_nacl_ephemeral_ports_egress" {
  network_acl_id = aws_network_acl.app_pub_nacl.id
  rule_number    = 299
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}
