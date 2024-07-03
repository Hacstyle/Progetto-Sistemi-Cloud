# Configure the AWS provider
provider "aws" {
  region = "us-west-2"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Create a public subnet in Availability Zone 1
resource "aws_subnet" "public_az1" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}


# Create an instance in Availability Zone 1
resource "aws_instance" "ec2_m_az1" {
  ami                    = "ami-01572eda7c4411960"
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public_az1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<EOF
  #!/bin/bash
  echo "Copying the SSH Key to the server"
  echo -e "${tls_private_key.key.public_key_openssh}" >> /home/ubuntu/.ssh/authorized_keys
  EOF

  tags = {
     Name = "node"
  }
  key_name               = aws_key_pair.generated_key.key_name
}

resource "tls_private_key" "key" {
   algorithm = "RSA"
   rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
    key_name   = "my_key"
    public_key = tls_private_key.key.public_key_openssh
    }

# Create a route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block                = "10.0.0.0/16"
    vpc_peering_connection_id = null
    gateway_id                = "local"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.main.id
}

# Create a security group for the EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow inbound traffic on port 80 and 22"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
     from_port   = 30000
     to_port     = 32768
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  } 

}