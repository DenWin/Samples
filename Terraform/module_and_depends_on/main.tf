provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "rg" {
    name     = "rg"
    location = "West Europe"
#    tags     = { A = "B" }
}

module "network" {
    source                  = "./network_w_dataSource_modified"    # We are back to data sources - see within the modified module
    depends_on              = [azurerm_resource_group.rg]

    vnet_name               = "vnet"
    resource_group_name     = azurerm_resource_group.rg.name
    address_space           = [ "10.0.0.0/16" ]
}
