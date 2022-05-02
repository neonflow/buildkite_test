resource "aws_security_group" "siva-rc-web-sg" {
  name        = "siva-rc-web-sg"
  description = "SiVA RC Web server application specific rules"
  vpc_id      = local.workspace["vpc_id"]

  tags = merge(
    local.tags,
    {
      Name = "siva-rc-web-sg"
    },
  )
}

resource "aws_security_group_rule" "ingress-1" {
  type        = "ingress"
  description = "HTTPS private"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]

  security_group_id = aws_security_group.siva-rc-web-sg.id
}

resource "aws_security_group_rule" "ingress-2" {
  type        = "ingress"
  description = "HTTP private"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]

  security_group_id = aws_security_group.siva-rc-web-sg.id
}

resource "aws_security_group_rule" "ingress-3" {
  type        = "ingress"
  description = "memcache"
  from_port   = 11211
  to_port     = 11211
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]

  security_group_id = aws_security_group.siva-rc-web-sg.id
}


resource "aws_security_group_rule" "egress-1" {
  type        = "egress"
  description = "HTTPS private"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]

  security_group_id = aws_security_group.siva-rc-web-sg.id
}

resource "aws_security_group_rule" "egress-2" {
  type        = "egress"
  description = "HTTP private"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]

  security_group_id = aws_security_group.siva-rc-web-sg.id
}

resource "aws_security_group_rule" "egress-3" {
  type        = "egress"
  description = "memcache"
  from_port   = 11211
  to_port     = 11211
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]

  security_group_id = aws_security_group.siva-rc-web-sg.id
}

resource "aws_security_group_rule" "egress-4" {
  type        = "egress"
  description = "github-jenkins"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.siva-rc-web-sg.id
}
