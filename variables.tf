variable "ec2-type" {
  description = "Ec2 Instance Type"
  type=string
  default = "t2.micro"
}
#variable "key-pair" {
#  description = "keypair"
#  type = string
#  default= "zwaw"
#}

variable key_name {
  default = "zwaw"
  type    = string
}