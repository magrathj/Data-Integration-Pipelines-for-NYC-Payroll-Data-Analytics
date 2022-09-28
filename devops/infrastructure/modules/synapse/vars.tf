variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "synapse_workspace_name" {
  type = string
}

variable "storage_data_lake_gen2_filesystem_id" {
  type = string
}

variable "synapse_sql_administrator_login" {
  sensitive = true
  type = string
}

variable "synapse_sql_administrator_password" {
  sensitive = true
  type = string
}

variable "synapse_sql_pool_name" {
  type = string
}