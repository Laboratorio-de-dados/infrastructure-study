

resource "aws_vpc" "josue" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "JOSUE"
  }
}

resource "aws_subnet" "publica_01" {
  vpc_id     = aws_vpc.josue.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "SUBPUBLICA_01"
  }
}

resource "aws_subnet" "publica_02" {
  vpc_id     = aws_vpc.josue.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "SUBPUBLICA_02"
  }
}


resource "aws_subnet" "privada_01" {
  vpc_id     = aws_vpc.josue.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "SUBPRIVADA_01"
  }
}

resource "aws_subnet" "privada_02" {
  vpc_id     = aws_vpc.josue.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "SUBPRIVADA_02"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.josue.id

  tags = {
    name = "gw-prd"
  }
}


resource "aws_route_table" "rt-publica_01" {
  vpc_id = aws_vpc.josue.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "rt-publica_02" {
  vpc_id = aws_vpc.josue.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public-association-01" {
  subnet_id      = aws_subnet.publica_01.id
  route_table_id = aws_route_table.rt-publica_01.id
}

resource "aws_route_table_association" "public-association-02" {
  subnet_id      = aws_subnet.publica_02.id
  route_table_id = aws_route_table.rt-publica_02.id
}


resource "aws_security_group" "WEB-API" {
  name        = "web"
  description = "web api"
  vpc_id      = aws_vpc.josue.id

  tags = {
    Name = "webapi"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  security_group_id = aws_security_group.WEB-API.id
  cidr_ipv4         = aws_vpc.josue.cidr_block

  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.WEB-API.id
  cidr_ipv4         = aws_vpc.josue.cidr_block

  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}


resource "aws_iam_instance_profile" "role-ec2" {
  name = "role-existing-profile"
  role = data.aws_iam_role.role-ssm.name
}


resource "aws_instance" "WEB-API" {
  ami             = "ami-0f3f13f145e66a0a3"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.WEB-API.id]

  subnet_id            = aws_subnet.publica_01.id
  iam_instance_profile = aws_iam_instance_profile.role-ec2.name

  user_data = ("${path.module}/installVm.sh")

}

output "INSTANCE-ID" {
  value = aws_instance.WEB-API.id
}
output "INSTANCE-NAME" {
  value = aws_instance.WEB-API.key_name
}