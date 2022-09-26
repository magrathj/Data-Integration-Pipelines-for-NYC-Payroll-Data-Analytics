provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}-rg"
  location = var.location

  tags = {
    udacity = "${var.resource_group_name}-data-warehouse"
  }

}

resource "azurerm_postgresql_server" "main" {
  name                = "${var.postgres_name}-postgres"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.main.name

  administrator_login          = var.postgres_administrator_login 
  administrator_login_password = var.postgres_administrator_password 

  sku_name   = "GP_Gen5_4"
  version    = "11"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_storage_account" "main" {
  name                     = "${var.storage_acct_name}storageacc"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "main" {
  name               = "${var.data_lake_name}storagedatalake"
  storage_account_id = azurerm_storage_account.main.id
}

resource "azurerm_storage_container" "main" {
  name                  = "raw"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_synapse_workspace" "main" {
  name                                 = "${var.synapse_workspace_name}synapse"
  resource_group_name                  = azurerm_resource_group.main.name
  location                             = azurerm_resource_group.main.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.main.id
  sql_administrator_login              = var.synapse_sql_administrator_login
  sql_administrator_login_password     = var.synapse_sql_administrator_password

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Env = "test"
  }
}

resource "azurerm_synapse_sql_pool" "main" {
  name                 = "${var.synapse_sql_pool_name}synapse"
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  sku_name             = "DW100c"
  create_mode          = "Default"
}