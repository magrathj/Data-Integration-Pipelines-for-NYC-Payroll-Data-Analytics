variable "resource_group_name" {
    type = string
}

variable "location" {
    type = string
}

variable "adf_name" {
    type = string
}

variable "primary_connection_string_blob" {
    sensitive = true
    type = string
}

variable "primary_connection_string_sql" {
    sensitive = true
    type = string
}

variable "primary_connection_string_synapse" {
    sensitive = true
    type = string
}