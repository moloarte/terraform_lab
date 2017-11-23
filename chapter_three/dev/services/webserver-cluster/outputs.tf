# Output things
output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}

output "server_port" {
  value = "${var.server_port}"
}
