provider "aws" {
    region = "us-east-1"
}
# Variable Section
variable "server_port" { 
    description = "The port the server will use for HTTP requests"
    default = 8080
}
variable "ssh_port" { 
    description = "The port the server will use for SSH requests"
    default = 22
}
# Declaring resources
resource "aws_launch_configuration" "example" {
    image_id        = "ami-40d28157"
    instance_type   = "t2.micro"
    security_groups = ["${aws_security_group.instance.id}"]

    user_data = "${data.template_file.shell_script_example.rendered}" 

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "example" {
    launch_configuration = "${aws_launch_configuration.example.id}"
    availability_zones   = ["${data.aws_availability_zones.all.names}"]

    min_size = 2
    max_size = 10

    tag {
        key                 = "Name"
        value               = "terraform-asg-example"
        propagate_at_launch = true
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
    lifecycle {
        create_before_destroy = true
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
    lifecycle {
        create_before_destroy = true
    }
}
# Script to provision
data "template_file" "shell_script_example" {
    template = "${file(format("%s/templates/sh.template", path.module))}"
    vars {
        server_port = "${var.server_port}"
    }
}
# State can be either: available, information, impaired, or unavailable
data "aws_availability_zones" "all" {}
# Output things
output "server_port" {
   value = "${var.server_port}"
}