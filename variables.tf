variable "cidr_block" {
  type    = list(string)
  default = ["10.0.0.0/16", "10.0.1.0/24"]
}

variable "ports" {
  type    = list(number)
  default = [22, 80, 443, 8080, 8081]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_type_for_nexus" {
  type    = string
  default = "t2.medium"
}

variable "ami" {
  type    = string
  default = "ami-0c02fb55956c7d316"
}

variable "key_name" {
    type = string
    default = "adminmaster"
}