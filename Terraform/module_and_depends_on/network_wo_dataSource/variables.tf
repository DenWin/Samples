variable "vnet_name" {
    type        = string
}

variable "resource_group_name" {
    type        = string
}

variable "resource_group_location" {
    type        = string
}

variable "address_space" {
    type        = list(string)
}
