variable "AWS_REGION" {
  type    = string
  default = "eu-central-1"
}

variable "vpc_cidr" {
  default = "10.10.10.0/24"
}

variable "domain" {
  default = "es-for-eks"
}

variable "cidr_my_pool" {
  default = "188.230.111.0/24"
}

#Instance
variable "key_name" {
  description = "Name key for ssh"
  type        = string
  default     = "skozakov" #key-aws
}

variable "ami" {
  description = "ami for Amazon Linux 2 AMI"
  type        = string
  default     = "ami-0db9040eb3ab74509"
}

variable "ins_type" {
  description = "Instance type"
  type = string
  default = "t2.micro"
}

#Elasticsearch
variable "user_name_kibana" {
  default = "skozakov"
}

variable "user_pass_kibana" {
  default = "R@dik@lfiRe92"
}

variable "enabled" {
  type = bool
  default = true
  description = "setting up to true to create rule for default resource"
}