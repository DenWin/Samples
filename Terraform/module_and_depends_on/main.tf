provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "Step1" {
    name     = "Step1"
    location = "West Europe"
#    tags     = { A = "B" }
}
