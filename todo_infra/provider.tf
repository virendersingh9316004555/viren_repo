terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }
}


provider "azurerm" {
  features {}
  subscription_id = "f0ea4d91-8845-4cde-80fa-52ca5703a10a"
  # Configuration options
}