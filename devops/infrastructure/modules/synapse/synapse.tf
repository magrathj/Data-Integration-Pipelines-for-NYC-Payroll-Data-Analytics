resource "azurerm_synapse_workspace" "main" {
  name                                 = "${var.synapse_workspace_name}synapse"
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.storage_data_lake_gen2_filesystem_id
  sql_administrator_login              = var.synapse_sql_administrator_login
  sql_administrator_login_password     = var.synapse_sql_administrator_password

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Env = "test"
  }
}

resource "azurerm_synapse_firewall_rule" "main" {
  name                 = "AllowAll"
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"
}

resource "azurerm_synapse_sql_pool" "main" {
  name                 = "${var.synapse_sql_pool_name}synapse"
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  sku_name             = "DW100c"
  create_mode          = "Default"
}