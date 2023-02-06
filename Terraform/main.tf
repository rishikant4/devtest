data "aws_ami" "ubuntu-linux-1404" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "dev_machine" {
  ami = data.aws_ami.ubuntu-linux-1404.id
  instance_type = "t2.micro"
  key_name = "jen"

  tags = {
    Environment = "dev"
    Name = "${var.name}-server"
  }
}
