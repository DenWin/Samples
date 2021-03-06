

locals {
    identifier = format( "%s%s", var.resource_group_namem, data.azurerm_resource_group.network.location )
}

data "azurerm_resource_group" "network" {
    name = var.resource_group_name
}

data "azurerm_client_config" "current" {
}

resource "azurerm_virtual_network" "vnet" {
    lifecycle {
        ignore_changes = [ location, resource_group_name ]
    }
    for_each = { ( local.identifier ) =  1 }
    name                = var.vnet_name
    resource_group_name = data.azurerm_resource_group.network.name
    location            = data.azurerm_resource_group.network.location
    address_space       = var.address_space
}
