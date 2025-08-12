resource "aws_security_group" "app_pv_sg" {
  name        = "app-sg-db"
  description = "Security group for database instances"
  vpc_id      = aws_vpc.app_vpc.id

  tags = {
    Name = "app-sg-db"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_pv_sg_ssh_ingress" {
  description       = "Acesso a maquina via ssh"
  security_group_id = aws_security_group.app_pv_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = aws_vpc.app_vpc.cidr_block
}

resource "aws_vpc_security_group_ingress_rule" "app_pv_sg_mongodb_ingress" {
  description                  = "Acesso ao MongoDB"
  security_group_id            = aws_security_group.app_pv_sg.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.app_pub_sg.id
}

resource "aws_vpc_security_group_egress_rule" "app_pv_sg_http_egress" {
  description       = "Permite saida HTTP (porta 80) para a VPC"
  security_group_id = aws_security_group.app_pv_sg.id
  to_port           = 80
  from_port         = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "app_pv_sg_https_egress" {
  description       = "Permite saida HTTPS (porta 443) para a VPC"
  security_group_id = aws_security_group.app_pv_sg.id
  to_port           = 443
  from_port         = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "app_pv_sg_dns_tcp_egress" {
  description       = "Permite saida DNS (porta 53) para a VPC"
  security_group_id = aws_security_group.app_pv_sg.id
  to_port           = 53
  from_port         = 53
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "app_pv_sg_dns_udp_egress" {
  description       = "Permite saida DNS (porta 53) para a VPC"
  security_group_id = aws_security_group.app_pv_sg.id
  to_port           = 53
  from_port         = 53
  ip_protocol       = "udp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_network_acl" "app_private_nacl" {
  vpc_id     = aws_vpc.app_vpc.id
  subnet_ids = [aws_subnet.app_subnet_private.id]
  tags = {
    "Name" = "app-private-nacl"
  }
}

resource "aws_network_acl_rule" "app_private_nacl_ssh_ingress" {
  network_acl_id = aws_network_acl.app_private_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "app_private_nacl_ephemeral_ports_ingress" {
  network_acl_id = aws_network_acl.app_private_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "app_private_nacl_http_egress" {
  network_acl_id = aws_network_acl.app_private_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "app_private_nacl_https_egress" {
  network_acl_id = aws_network_acl.app_private_nacl.id
  rule_number    = 210
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "app_private_nacl_dns_tcp_egress" {
  network_acl_id = aws_network_acl.app_private_nacl.id
  rule_number    = 220
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "app_private_nacl_dns_udp_egress" {
  network_acl_id = aws_network_acl.app_private_nacl.id
  rule_number    = 230
  egress         = true
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "app_private_nacl_ephemeral_ports_egress" {
  network_acl_id = aws_network_acl.app_private_nacl.id
  rule_number    = 299
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}
