output "adlsid" {
  value = azurerm_storage_data_lake_gen2_filesystem.adlsnycpayroll.id
}

output "connection_string" {
  value = azurerm_storage_account.adlsnycpayroll.primary_connection_string
}