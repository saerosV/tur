# Just notes on Terraform's syntax and certain functionalities

# Resource syntax
# resource "<PROVIDER>_<TYPE>" "<NAME>" {
# [CONFIG ...]
# }

# Input variable syntax
#
#  variable "NAME" {
#
# Optional parameters:
# 
# description = ""
# type = can be: string, number, bool, list, map, set, object, tuple, any
# default = value
# }

# Output variable syntax
#
# output "<NAME>" {
#
# value = <VALUE>
# 
# Optional parameters:
# description = ""
# sensitive = Set to true to instruct Terraform not to log the output at the end of "TF apply".
#             Useful if the output variable contains sensitive (confidencial) material, like credentials 
#}



provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  #                        <PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE>
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  tags = {
    Name = "terraform-example"
  }
}

variable "server_port" { 
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  
  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

