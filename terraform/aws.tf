provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_vpc" "livegrep" {
  cidr_block = "10.0.1.0/24"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "livegrep" {
  vpc_id = "${aws_vpc.livegrep.id}"
  tags = {
    Name = "livegrep"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.livegrep.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.livegrep.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.livegrep.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "base" {
  name        = "base"
  description = "base security group"
  vpc_id      = "${aws_vpc.livegrep.id}"

  ingress {
    from_port = -1
    to_port = -1
    protocol = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ssh
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "livegrep_frontend" {
  name        = "livegrep-frontend"
  description = "livegrep frontend web server"
  vpc_id      = "${aws_vpc.livegrep.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9999
    to_port     = 9999
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "livegrep_backend" {
  name        = "livegrep-backend"
  description = "livegrep backend index server"
  vpc_id      = "${aws_vpc.livegrep.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 8910
    to_port     = 8910
    protocol    = "tcp"
    security_groups = ["${aws_security_group.livegrep_frontend.id}"]
  }
}
