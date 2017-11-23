# Variable Section
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

variable "ssh_port" {
  description = "The port the server will use for SSH requests"
  default     = 22
}

variable "http_balancer_port" {
  description = "The port that is balanced by the aws_elb example resource"
  default     = 80
}
