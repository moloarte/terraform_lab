provider "aws" {
    region = "us-east-1"
}
variable "server_port" { 
    description = "The port the server will use for HTTP requests"
    default = 8080
}
variable "ssh_port" { 
    description = "The port the server will use for SSH requests"
    default = 22
}

resource "aws_instance" "example" {
    ami                    = "ami-40d28157"
    instance_type          = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

    user_data = "${data.template_file.shell_script_example.rendered}" 

    tags = {
        Name = "terraform-example"
    }
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

    ingress {
        from_port   = "${var.server_port}"
        to_port     = "${var.server_port}"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "ssh_in" {
    name = "terraform-ssh-instance"

    ingress {
        from_port   = "${var.ssh_port}"
        to_port     = "${var.ssh_port}"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "template_file" "shell_script_example" {
    template = "${file(format("%s/templates/sh.template", path.module))}"
    vars {
        server_port = "${var.server_port}"
    }
}
output "public_ip" {
    value = "${aws_instance.example.public_ip}"
}
output "server_port" {
   value = "${var.server_port}"
}