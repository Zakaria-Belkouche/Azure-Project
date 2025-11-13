terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}


provider "azurerm" {
  features {}

  subscription_id = "b2284af9-01b7-4db2-880d-1ca4147dc2b0"
  tenant_id = "525d3c56-e85e-407e-8a8b-ac800df218d2"
}