variable "public_subnet_web_tag" {
  type = string
  #   default     = "public-subnet-web"
}

variable "private_subnet_app_tag" {
  type = string
  #   default     = "private-subnet-app"  
}

variable "private_subnet_database_tag" {
  type = string
  #   default     = "private-subnet-database"  
}
variable "private_subnet_direct_to_vpc_tag" {
  type = string
}

variable "vpc_name" {
  type = string
}