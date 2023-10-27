############# Environment Variable #######################

variable "environment" {
  type    = string
  default = "prod"
}

############# Provisionner Variable #######################

variable "provisioner" {
  type    = string
  default = "Terraform"
}

################## Public Security Group name variable ####################

variable "public_sg_name" {
  type    = string
  default = "public-sg"
}

################## Private Security Group name variable ####################

variable "private_sg_name" {
  type    = string
  default = "private-sg"
}

################## Bastion name variable ####################

variable "bastion_sg_name" {
  type    = string
  default = "bastion-sg"
}

################## Public and Private Subnet Names variables ####################
variable "public_subnet_names" {
  type    = list(string)
  default = ["public-subnet-1", "public-subnet-2", "public-subnet-3"]
}

variable "private_subnet_names" {
  type    = list(string)
  default = ["private-subnet-1", "private-subnet-2", "private-subnet-3"]
}
################## Instance Type variable ####################

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

#################### Key Pair Variable ########################

variable "key_pair_use2" {
  type    = string
  default = "main-us-east-2"
}

################## Ports and Protocols variables ####################

variable "port_443" {
  type    = number
  default = "443"
}

variable "protocol_443" {
  type    = string
  default = "HTTPS"
}

variable "port_80" {
  type    = number
  default = "80"
}

variable "protocol_80" {
  type    = string
  default = "HTTP"
}

variable "port_22" {
  type    = number
  default = "22"
}

variable "protocol_tcp" {
  type    = string
  default = "TCP"
}
