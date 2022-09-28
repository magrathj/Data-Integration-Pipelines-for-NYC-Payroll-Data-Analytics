resource "azurerm_sql_server" "udacity_sqlserver" {
  name                         = "udacitysqlserverjared"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.username
  administrator_login_password = var.password
}

resource "azurerm_sql_firewall_rule" "example" {
  name                = "FirewallRule1"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.udacity_sqlserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_database" "udacity_sql_database" {
  name                = "udacitysqldatabasejared"
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.udacity_sqlserver.name
}