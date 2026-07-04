
variable "name" {}
variable "db_name" {}
variable "username" {}
variable "password" {}

variable "engine_version" {
  default = "15.5"
}

variable "instance_class" {
  default = "db.t3.micro"
}

variable "allocated_storage" {
  default = 20
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
