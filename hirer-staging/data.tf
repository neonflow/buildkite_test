data "aws_security_group" "common-linux-sg" {
  name = "common-linux-sg"
}

data "aws_security_group" "siva-rc-web-sg" {
  name = "siva-rc-web-sg"
}

data "aws_security_group" "migration-test-all-nothing" {
  name = "migration-test-all-nothing"
}

