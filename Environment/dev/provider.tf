terraform {
    backend "azurerm" {
    resource_group_name  = "pipe-line-rg"
    storage_account_name = "pipelinestorageact"
    container_name       = "pipeline-container"
    key                  = "pipeline.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.57.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "86c2c7ab-0841-425a-9004-95c83c2075de"
}