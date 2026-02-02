
resource "azurerm_resource_group" "rs1" {
    name     = "himanshu-resource-group-one"
    location = var.location
  
}

resource "azurerm_resource_group" "rs2" {
    name     = "himanshu-resource-group-two"
    location = var.location
}

resource "azurerm_virtual_network" "vnet1" {
    name                = var.vnet-name
  location            = azurerm_resource_group.rs1.location
  resource_group_name = azurerm_resource_group.rs1.name
  address_space       = ["10.0.0.0/16"]
  
}
resource "azurerm_subnet" "vnet-sub1" {
    name                 = "${var.vnet-name}-subnet1"
  resource_group_name  = azurerm_resource_group.rs1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
  
}



