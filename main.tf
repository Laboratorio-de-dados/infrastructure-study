resource "aws_vpc" "josue" {
  cidr_block       = "10.0.0.0/25"
  instance_tenancy = "default"

  tags = {
    name = "JOSUE"
  }
}

resource "aws_subnet" "publica" {
  vpc_id     = aws_vpc.josue.id
  cidr_block = "10.0.0.0/26"

  tags = {
    name = "SUBPUBLICA"
  }
}

resource "aws_subnet" "privada" {
  vpc_id     = aws_vpc.josue.id
  cidr_block = "10.0.0.64/26"

  tags = {
    name = "SUBPRIVADA"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.josue.id

  tags = {
    name = "gw-prd"
  }
}


resource "aws_route_table" "rt-publica" {
  vpc_id = aws_vpc.josue.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

}

resource "aws_route_table_association" "public-association" {
  subnet_id      = aws_subnet.publica.id
  route_table_id = aws_route_table.rt-publica.id
}

resource "aws_security_group" "WEB-API" {
  name = "web"
  description = "web api"
  vpc_id = aws_vpc.josue.id

  tags = {
    name = "webapi"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  security_group_id = aws_security_group.WEB-API.id
  cidr_ipv4 = aws_vpc.josue.cidr_block

  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.WEB-API.id
  cidr_ipv4 = aws_vpc.josue.cidr_block

  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}


resource "aws_iam_instance_profile" "role-ec2" {
  name = "role-existing-profile"
  role = data.aws_iam_role.role-ssm.name
}


resource "aws_instance" "WEB-API" {
  ami           = "ami-0f3f13f145e66a0a3"
  instance_type = "t3.micro"
  security_groups = [ aws_security_group.WEB-API.id ]

  subnet_id              = aws_subnet.publica.id
  iam_instance_profile = aws_iam_instance_profile.role-ec2.name
}

output "INSTANCE-ID" {
  value = aws_instance.WEB-API.id
}
output "INSTANCE-NAME" {
  value = aws_instance.WEB-API.key_name
}