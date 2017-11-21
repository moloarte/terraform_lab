provider "aws" {
    region = "us-east-1"
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
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "template_file" "shell_script_example" {
  template = "${file(format("%s/templates/sh.template", path.module))}"
}