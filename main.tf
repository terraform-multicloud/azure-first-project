
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

resource "azurerm_storage_account" "st1" {
    name                     = "himanshustorageaccnt1"
    resource_group_name      = azurerm_resource_group.rs1.name
    location                 = azurerm_resource_group.rs1.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
  
}

resource "azurerm_storage_container" "sc1" {
    name                  = "himanshucontainerone-bucket1"
    storage_account_id  = azurerm_storage_account.st1.id
    container_access_type = "private"
  
}

resource "azurerm_network_interface" "example" {
  name                = "${var.vnet-name}-nic1"
  location            = azurerm_resource_group.rs1.location
  resource_group_name = azurerm_resource_group.rs1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet-sub1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "${var.vnet-name}-vm1"
  resource_group_name = azurerm_resource_group.rs1.name
  location            = azurerm_resource_group.rs1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
    admin_password      = "P@ssword1234"

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}


resource "azurerm_network_security_group" "example" {
  name                = "${var.vnet-name}-nsg1"
  location            = azurerm_resource_group.rs1.location
  resource_group_name = azurerm_resource_group.rs1.name

  security_rule {
    name                       = "test1234"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "80"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "test123"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  
}






