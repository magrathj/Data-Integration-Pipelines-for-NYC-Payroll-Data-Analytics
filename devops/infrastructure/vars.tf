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


# synapse workspace
variable "synapse_workspace_name" {
  description = "name of postgres database to be created"
  default     = "udacityproject"
}

variable "synapse_sql_administrator_login" {
    default = "sqladminuser"
}

variable "synapse_sql_administrator_password" {}

# sql pool 
variable "synapse_sql_pool_name" {
  description = "name of postgres database to be created"
  default     = "udacity"
}


variable "adf_name"{
  description = "name of azure data factory to be created"
  default     = "udacityadfjared"
}