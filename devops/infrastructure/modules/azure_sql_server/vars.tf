variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "username" {
  sensitive = true
  type = string
}

variable "password" {
  sensitive = true
  type = string
}
