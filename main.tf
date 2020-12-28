# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "example" {
  name = "jimmy0924"
}

output "id" {
  value = "55c6b1fb-9d1d-4926-9864-9925de511d7b"
}