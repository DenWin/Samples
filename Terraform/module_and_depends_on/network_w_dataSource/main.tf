

data "azurerm_resource_group" "network" {
    name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
    name                = var.vnet_name
    resource_group_name = data.azurerm_resource_group.network.name
    location            = data.azurerm_resource_group.network.location
    address_space       = var.address_space
}
