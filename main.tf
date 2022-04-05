provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "pu_vpc" {
  cidr_block       = var.cidr_block[0]
  instance_tenancy = "default"

  tags = {
    Name = "pu_vpc"
  }
}

resource "aws_subnet" "pu_subnet" {
  vpc_id     = aws_vpc.pu_vpc.id
  cidr_block = var.cidr_block[1]

  tags = {
    Name = "pu_subnet"
  }
}

resource "aws_internet_gateway" "pu_igw" {
  vpc_id = aws_vpc.pu_vpc.id

  tags = {
    Name = "pu_igw"
  }
}

resource "aws_route_table" "pu_rt" {
  vpc_id = aws_vpc.pu_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pu_igw.id
  }


  tags = {
    Name = "pu_rt"
  }
}

resource "aws_route_table_association" "pu_rta" {
  subnet_id      = aws_subnet.pu_subnet.id
  route_table_id = aws_route_table.pu_rt.id
}


## Create security groups

resource "aws_security_group" "pu_sg" {
  name        = "pu-sg"
  description = "To allow inbound and outbound traffic"
  vpc_id      = aws_vpc.pu_vpc.id



  dynamic "ingress" {
    iterator = port
    for_each = var.ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 is semantically equal to all, it means all protocol, this will work when you have from port and to port as 0
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "pu-sg"
  }

}



resource "aws_instance" "pu_jenkins" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.pu_sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.pu_subnet.id
  user_data                   = file("./installjenkins.sh")



  tags = {
    Name = "pu_jenkins-server"
  }
}

resource "aws_instance" "pu_ansiblecontroller" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.pu_sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.pu_subnet.id
  user_data                   = file("./InstallAnsibleCN.sh")



  tags = {
    Name = "pu_ansiblecontroller"
  }
}

resource "aws_instance" "pu_ansibleManagednode1" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.pu_sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.pu_subnet.id
  user_data                   = file("./AnsibleMN.sh")



  tags = {
    Name = "pu_ansibleMN1"
  }
}

resource "aws_instance" "pu_DockerHost" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.pu_sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.pu_subnet.id
  user_data                   = file("./Docker.sh")



  tags = {
    Name = "pu_DockerHost"
  }
}

resource "aws_instance" "pu_Nexus" {
  ami                         = var.ami
  instance_type               = var.instance_type_for_nexus
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.pu_sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.pu_subnet.id
  user_data                   = file("./InstallNexus.sh")



  tags = {
    Name = "pu_Nexus"
  }
}