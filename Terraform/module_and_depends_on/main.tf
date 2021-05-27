provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "example" {
    name     = "my-resources"
    location = "West Europe"
#    tags     = { A = "B" }
}

/*
module "network" {
    source                  = "./network_w_dataSource"
    depends_on              = [azurerm_resource_group.example]

    vnet_name               = "vnet"
    resource_group_name     = azurerm_resource_group.example.name
#    resource_group_location = azurerm_resource_group.example.location
    address_space           = [ "10.0.0.0/16" ]
}
*/

/*
module "network" {
    source                  = "./network_wo_dataSource"
    depends_on              = [azurerm_resource_group.example]

    vnet_name               = "vnet"
    resource_group_name     = azurerm_resource_group.example.name
    resource_group_location = azurerm_resource_group.example.location
    address_space           = [ "10.0.0.0/16" ]
}
*/

/*
module "network" {
    source                  = "./network_w_dataSource_modified"
    depends_on              = [azurerm_resource_group.example]

    vnet_name               = "vnet"
    resource_group_name     = azurerm_resource_group.example.name
#    resource_group_location = azurerm_resource_group.example.location
    address_space           = [ "10.0.0.0/16" ]
}
*/
