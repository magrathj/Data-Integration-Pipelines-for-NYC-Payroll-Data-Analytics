variable "resource_group_name" {
    description = "rsg for the virtual machine's name which will be created"
    default     = "udacity-project"
}

variable "location" {
  description = "azure region where resources will be located .e.g. northeurope"
  default     = "UK South"
}

# Postgres
variable "postgres_name" {
  description = "name of postgres database to be created"
  default     = "udacity"
}

variable "postgres_administrator_login" {
    default = "psqladmin"
}

variable "postgres_administrator_password" {}

# storage account
variable "storage_acct_name" {
  description = "name of postgres database to be created"
  default     = "udacity"
}

# data lake account
variable "data_lake_name" {
  description = "name of postgres database to be created"
  default     = "udacity"
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
