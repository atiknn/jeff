data "aws_ami" "ec2_amazon" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
/*resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.ec2_amazon.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  subnet_id                   = data.terraform_remote_state.level1.outputs.private_subnet_id[1]

  user_data = file("user-data.sh")

  tags = {
    Name = "${var.environment_code}_main_ec2_instance"
  }
}*/

/*resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
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
    Name = "allow_tls"
  }
}*/

resource "aws_security_group" "aws_security_group_instance" {
  name = "aws-security-group-instance"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.aws_security_group_lb.id]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.aws_security_group_lb.id]
  }

  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id
}