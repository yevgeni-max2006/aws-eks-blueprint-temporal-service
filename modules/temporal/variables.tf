variable "db_host" {
  type = string
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type      = string
  default = "q1w2e3r4100@admin"
  sensitive = true
}

variable "namespace" {
  type    = string
  default = "temporal"
}
