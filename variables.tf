variable "vpc_cidr" {
  type    = string
  default = "10.124.0.0/16"
}

variable "access_ip" {
  type    = string
  default = "47.183.232.148/32"
}

variable "cloud9_ip" {
  type    = string
  default = "34.206.158.117/32"
}

variable "main_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "main_vol_size" {
  type    = number
  default = 8
}

variable "main_instance_count" {
  type    = number
  default = 1
}

variable "key_name" {
  type = string
}

variable "public_key_path" {
  type = string
}