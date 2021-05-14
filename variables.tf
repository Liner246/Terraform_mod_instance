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


#Count of Jenkins workers
variable "workers-count" {
  type    = number
  default = 1
}