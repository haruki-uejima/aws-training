####################################################
# Security Group
####################################################
# 外部からの HTTP,HTTPSアクセスを許可
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "allow http,https access."
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "allow http access."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow https access."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "alb"
  }
}

# 上記に関連付けられた SG からの内部アクセスを許可
resource "aws_security_group" "allow_internal" {
  name        = "allow_internal"
  description = "allow internal access."
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "allow internal http access."
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_http.id]
  }

  ingress {
    description     = "allow internal https access."
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_http.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "internal"
  }
}
