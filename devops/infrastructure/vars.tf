variable "resource_group_name" {
    description = "rsg for the virtual machine's name which will be created"
    default     = "udacity-project"
}

variable "location" {
  description = "azure region where resources will be located .e.g. northeurope"
  default     = "UK South"
}

variable "user_name" {
  description = "users name"
  default     = "jared"
}

variable "user_second_initial" {
  description = "users name"
  default     = "m"
}


variable "sql_password" {
  description = "sql database password"
}