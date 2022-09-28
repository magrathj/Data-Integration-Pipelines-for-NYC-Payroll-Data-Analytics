provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}-rg"
  location = var.location

  tags = {
    udacity = "${var.resource_group_name}-data-factory"
    creator = "Terraform"
    project = "Data Integration Pipelines for NYC Payroll Data Analytics"
  }

}

# Create Key Vault
resource "azurerm_key_vault" "terraform_backend_vault" {
  name                        = "udacity-tf-backend-vault"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name  

  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Delete", "Get", "List", "Purge", "Set", "Recover"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_secret" "sql_username" {
  name         = "sql-server-username"
  key_vault_id = azurerm_key_vault.terraform_backend_vault.id
  value        = "udacity"
}

resource "azurerm_key_vault_secret" "sql_password" {
  name = "sql-server-password"
  key_vault_id = azurerm_key_vault.terraform_backend_vault.id
  value        = var.sql_password
}

module "blob_storage" {
  source = "./modules/blob_storage"

  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  user_name = var.user_name
  user_second_initial = var.user_second_initial
}

module "sql_database" {
  source = "./modules/azure_sql_server"

  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  username = azurerm_key_vault_secret.sql_username.value
  password = azurerm_key_vault_secret.sql_password.value
}

resource "azurerm_key_vault_secret" "synapse_username" {
  name         = "synapse-sql-administrator-login"
  key_vault_id = azurerm_key_vault.terraform_backend_vault.id
  value        = var.synapse_sql_administrator_login
}

resource "azurerm_key_vault_secret" "synapse_password" {
  name         = "synapse-sql-administrator-password"
  key_vault_id = azurerm_key_vault.terraform_backend_vault.id
  value        = var.synapse_sql_administrator_password
}

module "synapse" {
  source = "./modules/synapse"

  resource_group_name                  = azurerm_resource_group.main.name
  location                             = azurerm_resource_group.main.location
  synapse_workspace_name               = var.synapse_workspace_name
  storage_data_lake_gen2_filesystem_id = module.blob_storage.adlsid
  synapse_sql_administrator_login      = azurerm_key_vault_secret.synapse_username.value
  synapse_sql_administrator_password   = azurerm_key_vault_secret.synapse_password.value
  synapse_sql_pool_name                = var.synapse_sql_pool_name
}


locals {
  sql_connection_string = "Server=tcp:${module.sql_database.server_name}.database.windows.net,1433;Initial Catalog=${module.sql_database.database_name};Persist Security Info=False;User ID=${azurerm_key_vault_secret.sql_username.value};Password=${azurerm_key_vault_secret.sql_password.value};MultipleActiveResultSets=True;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}

locals {
  primary_connection_string_synapse = "Integrated Security=False;Data Source=${var.synapse_workspace_name}synapse;Initial Catalog=${var.synapse_sql_pool_name}synapse;User ID=${azurerm_key_vault_secret.synapse_username.value};Password=${azurerm_key_vault_secret.synapse_password.value}"
}

module "adf" {
  source = "./modules/adf"

  resource_group_name                  = azurerm_resource_group.main.name
  location                             = azurerm_resource_group.main.location
  adf_name                             = var.adf_name
  primary_connection_string_blob       = module.blob_storage.connection_string
  primary_connection_string_sql        = local.sql_connection_string
  primary_connection_string_synapse    = local.primary_connection_string_synapse
}

