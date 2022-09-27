resource "azurerm_storage_account" "adlsnycpayroll" {
    name = "adlsnycpayroll${var.user_name}${var.user_second_initial}"
    resource_group_name = var.resource_group_name
    location = var.location
    account_tier = "Standard"
    account_replication_type = "LRS"

    tags = {
        creator = "Terraform"
        project = "Data Integration Pipelines for NYC Payroll Data Analytics"
    }
}

# # create containers 
resource "azurerm_storage_container" "dirpayrollfiles" {
  name                  = "dirpayrollfiles"
  storage_account_name  = azurerm_storage_account.adlsnycpayroll.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "dirhistoryfiles" {
  name                  = "dirhistoryfiles"
  storage_account_name  = azurerm_storage_account.adlsnycpayroll.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "dirstaging" {
  name                  = "dirstaging"
  storage_account_name  = azurerm_storage_account.adlsnycpayroll.name
  container_access_type = "private"
}


# upload files to blob
resource "azurerm_storage_blob" "EmpMaster" {
  name                   = "EmpMaster.csv"
  storage_account_name   = azurerm_storage_account.adlsnycpayroll.name
  storage_container_name = azurerm_storage_container.dirpayrollfiles.name
  type                   = "Block"
  source                 = "./data/EmpMaster.csv"

  metadata = {
        creator = "Terraform"
        project = "Data Integration Pipelines for NYC Payroll Data Analytics"
  }
}

resource "azurerm_storage_blob" "AgencyMaster" {
  name                   = "AgencyMaster.csv"
  storage_account_name   = azurerm_storage_account.adlsnycpayroll.name
  storage_container_name = azurerm_storage_container.dirpayrollfiles.name
  type                   = "Block"
  source                 = "./data/AgencyMaster.csv"

  metadata = {
        creator = "Terraform"
        project = "Data Integration Pipelines for NYC Payroll Data Analytics"
  }
}


resource "azurerm_storage_blob" "TitleMaster" {
  name                   = "TitleMaster.csv"
  storage_account_name   = azurerm_storage_account.adlsnycpayroll.name
  storage_container_name = azurerm_storage_container.dirpayrollfiles.name
  type                   = "Block"
  source                 = "./data/TitleMaster.csv"

  metadata = {
        creator = "Terraform"
        project = "Data Integration Pipelines for NYC Payroll Data Analytics"
  }
}

resource "azurerm_storage_blob" "nycpayroll_2021" {
  name                   = "nycpayroll_2021.csv"
  storage_account_name   = azurerm_storage_account.adlsnycpayroll.name
  storage_container_name = azurerm_storage_container.dirpayrollfiles.name
  type                   = "Block"
  source                 = "./data/nycpayroll_2021.csv"

  metadata = {
        creator = "Terraform"
        project = "Data Integration Pipelines for NYC Payroll Data Analytics"
  }
}


resource "azurerm_storage_blob" "nycpayroll_2020" {
  name                   = "nycpayroll_2020.csv"
  storage_account_name   = azurerm_storage_account.adlsnycpayroll.name
  storage_container_name = azurerm_storage_container.dirhistoryfiles.name
  type                   = "Block"
  source                 = "./data/nycpayroll_2020.csv"

  metadata = {
        creator = "Terraform"
        project = "Data Integration Pipelines for NYC Payroll Data Analytics"
  }
}