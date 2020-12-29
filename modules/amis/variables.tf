variable "ecs_amis" {
  type        = "map"
  description = "map of region to ami for ecs nodes"

  default = {
"ap-southeast-2" = "ami-0bda02c332411c441"
"eu-west-1"      = "ami-0f4d06c6ca22ec63a"
"us-east-1"      = "ami-038486981e55defbf"
"us-east-2"      = "ami-096cfb7393c5e200f"
"us-west-2"      = "ami-0d63765f3be9d0279"
  }
}

variable "mlservices_amis" {
  type        = "map"
  description = "map of region to ami for mlservices nodes"

  default = {
    "ap-southeast-2" = "ami-03627b31e24c1ed4d"
    "eu-west-1"      = "ami-0eb1bb29341d1c613"
    "us-east-1"      = "ami-0cef9e4b247eb1858"
    "us-east-2"      = "ami-0a1ef4eaf67d02ea3"
    "us-west-2"      = "ami-0af107b247c566af6"
  }
}

variable "proxy_amis" {
  type        = "map"
  description = "map of region to ami for proxy nodes"

  default = {
    "ap-southeast-2" = "ami-0a1691fd6f93515b1"
    "eu-west-1"      = "ami-000b01e3bac8199d0"
    "us-east-1"      = "ami-0dd59bb55f41d7969"
    "us-east-2"      = "ami-020c0040a6c23fd0d"
    "us-west-2"      = "ami-0d2eb0a4e73d884d7"
  }
}

variable "services_amis" {
  type        = "map"
  description = "map of region to ami for services nodes"

  default = {
"ap-southeast-2" = "ami-0091849b0b24913af"
"eu-west-1"      = "ami-00eb9f88f82c8b00b"
"us-east-1"      = "ami-0d372bf52574dd3f0"
"us-east-2"      = "ami-06aadeaf0ad58cca0"
"us-west-2"      = "ami-06d9ddc09f856e020"
  }
}
