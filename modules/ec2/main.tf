# resource "aws_key_pair" "my-pub-key" {
#   key_name   = "my-pub-key"
#   public_key = file("${var.key_path}")
# }

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name   = "rahkat-aws-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "aws_instance" "apache2-instance" {
  ami                         = "ami-0076b212fad243d9e"
  instance_type               = "t2.small"
  key_name                    = aws_key_pair.ssh.key_name
  vpc_security_group_ids      = [aws_security_group.apache2-instance-sg.id]
  subnet_id                   = aws_subnet.rahkat_vpc_public_Subnet.id
  associate_public_ip_address = true
  user_data                   = file("install.sh")
  root_block_device {
    volume_size           = 10
    delete_on_termination = true
  }

  tags = {
    Name = "apache2-instance"
  }
}

resource "aws_instance" "apache2-instance-private" {
  ami                         = "ami-0076b212fad243d9e"
  instance_type               = "t2.small"
  key_name                    = aws_key_pair.ssh.key_name
  vpc_security_group_ids      = [aws_security_group.apache2-instance-sg.id]
  subnet_id                   = aws_subnet.rahkat_vpc_private_Subnet.id
  associate_public_ip_address = false
  user_data                   = file("install.sh")
  root_block_device {
    volume_size           = 10
    delete_on_termination = true
  }

  tags = {
    Name = "apache2-instance-private"
  }
}

resource "aws_security_group" "apache2-instance-sg" {
  name        = "apache2-instance-SG"
  description = "apache2 instance server"

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

  vpc_id = aws_vpc.rahkat_vpc.id

  tags = {
    Name = "apache2-instance-SG"
  }
}