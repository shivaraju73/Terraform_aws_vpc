resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
      Name = "MainVPC"
  }
}

resource "aws_subnet" "subneta" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
      Name = "SubnetA"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainIGW"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "MainRouteTable"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.subneta.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "instance" {
  vpc_id = aws_vpc.main.id

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "InstanceSecurityGroup"
  }
}

resource "aws_key_pair" "mykey" {
  key_name   = "my-key"
  public_key = file("~/.ssh/my-key.pub")
}

resource "aws_instance" "first" {
  ami = var.ami_id
  instance_type = var.environment == "dev" ? var.instance_type_dev : var.instance_type_prod
  key_name = aws_key_pair.mykey.key_name
  subnet_id = aws_subnet.subneta.id
  vpc_security_group_ids = [aws_security_group.instance.id]
  
  tags = {
      Name = "FirstInstance"
  }
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file("~/.ssh/my-key")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install apache2 -y",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2",
      "echo 'Hello, Sanjay Lodu!' | sudo tee /var/www/html/index.html",
      "sudo systemctl restart apache2"
    ]
  }
}