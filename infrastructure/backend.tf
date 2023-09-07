terraform {
  backend "azurerm" {
    resource_group_name  = "base_config_rg"
    storage_account_name = "newlookterraformstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}