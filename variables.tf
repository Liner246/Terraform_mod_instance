variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

variable "instance-ami" {
  type    = string
  default = "ami-00399ec92321828f5"
}


variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-2"
}

variable "region-worker" {
  type    = string
  default = "us-east-2"
}

variable "server_port_8080" {
  description = "The port the server will use for 8080 access"
  type        = number
  default     = 8080
}

variable "server_port_ssh" {
  description = "The port the server will use for ssh access"
  type        = number
  default     = 22
}

variable "server_port_http" {
  description = "The port the server will use for HTTP access"
  type        = number
  default     = 80
}

variable "server_port_https" {
  description = "The port the server will use for HTTP access"
  type        = number
  default     = 443
}

#Count of Jenkins workers
variable "workers-count" {
  type    = number
  default = 1
}