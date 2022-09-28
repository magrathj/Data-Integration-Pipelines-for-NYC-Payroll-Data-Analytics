output "database_name" {
  value = azurerm_sql_database.udacity_sql_database.name
}

output "server_name" {
  value = azurerm_sql_server.udacity_sqlserver.name
}