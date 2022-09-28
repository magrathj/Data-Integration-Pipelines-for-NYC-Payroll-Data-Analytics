resource "azurerm_data_factory" "adf" {
  name                = var.adf_name
  location            = var.location
  resource_group_name = var.resource_group_name

  identity {
    type = "SystemAssigned"
  }

  tags = {
    creator = "Terraform"
    project = "Data Integration Pipelines for NYC Payroll Data Analytics"
  } 
}


resource "azurerm_data_factory_linked_service_azure_blob_storage" "linkedsource" {
  name                = "linkedservicesblobource"
  data_factory_id     = azurerm_data_factory.adf.id
  connection_string   = var.primary_connection_string_blob
}


resource "azurerm_data_factory_dataset_delimited_text" "nycpayroll_2021" {
  name                = "nycpayroll_2021"
  data_factory_id     = azurerm_data_factory.adf.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.linkedsource.name

  azure_blob_storage_location {
    container = "@dataset().container_name"
    filename = "nycpayroll_2021.csv"
  }
  parameters = { container_name = "dirpayrollfiles"}

  column_delimiter    = ","
  row_delimiter       = "NEW"
  encoding            = "UTF-8"
  quote_character     = "x"
  escape_character    = "f"
  first_row_as_header = true
  null_value          = "NULL"
}



resource "azurerm_data_factory_dataset_delimited_text" "EmpMaster" {
  name                = "EmpMaster"
  data_factory_id     = azurerm_data_factory.adf.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.linkedsource.name

  azure_blob_storage_location {
    container = "@dataset().container_name"
    filename = "EmpMaster.csv"
  }
  parameters = { container_name = "dirpayrollfiles"}

  column_delimiter    = ","
  row_delimiter       = "NEW"
  encoding            = "UTF-8"
  quote_character     = "x"
  escape_character    = "f"
  first_row_as_header = true
  null_value          = "NULL"
}


resource "azurerm_data_factory_dataset_delimited_text" "TitleMaster" {
  name                = "TitleMaster"
  data_factory_id     = azurerm_data_factory.adf.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.linkedsource.name

  azure_blob_storage_location {
    container = "@dataset().container_name"
    filename = "TitleMaster.csv"
  }
  parameters = { container_name = "dirpayrollfiles"}

  column_delimiter    = ","
  row_delimiter       = "NEW"
  encoding            = "UTF-8"
  quote_character     = "x"
  escape_character    = "f"
  first_row_as_header = true
  null_value          = "NULL"
}


resource "azurerm_data_factory_dataset_delimited_text" "AgencyMaster" {
  name                = "AgencyMaster"
  data_factory_id     = azurerm_data_factory.adf.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.linkedsource.name

  azure_blob_storage_location {
    container = "@dataset().container_name"
    filename = "AgencyMaster.csv"
  }
  parameters = { container_name = "dirpayrollfiles"}

  column_delimiter    = ","
  row_delimiter       = "NEW"
  encoding            = "UTF-8"
  quote_character     = "x"
  escape_character    = "f"
  first_row_as_header = true
  null_value          = "NULL"
}


resource "azurerm_data_factory_dataset_delimited_text" "nycpayroll_2020" {
  name                = "nycpayroll_2020"
  data_factory_id     = azurerm_data_factory.adf.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.linkedsource.name

  azure_blob_storage_location {
    container = "@dataset().container_name"
    filename = "nycpayroll_2020.csv"
  }
  parameters = { container_name = "dirhistoryfiles"}

  column_delimiter    = ","
  row_delimiter       = "NEW"
  encoding            = "UTF-8"
  quote_character     = "x"
  escape_character    = "f"
  first_row_as_header = true
  null_value          = "NULL"
}


resource "azurerm_data_factory_linked_service_azure_sql_database" "linkedsql" {
  name              = "linkedservicesql"
  data_factory_id   = azurerm_data_factory.adf.id
  connection_string = var.primary_connection_string_sql
}

resource "azurerm_data_factory_linked_service_synapse" "linkedsynapse" {
  name            = "linkedservicesynapse"
  data_factory_id = azurerm_data_factory.adf.id

  connection_string = var.primary_connection_string_synapse
}