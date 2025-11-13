resource "azurerm_resource_group" "Project" {
    name = "Project-Directory"
    location = "West Europe"
}

resource "azurerm_virtual_network" "Project-Network" {
    name = "Project-Network"
    resource_group_name = azurerm_resource_group.Project.name
    location = "West Europe"
    address_space = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "Public-1" {
    name = "Public-1"
    resource_group_name = azurerm_resource_group.Project.name
    virtual_network_name = azurerm_virtual_network.Project-Network.name
    address_prefixes = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "Private-1" {
    name = "Private-1"
    resource_group_name = azurerm_resource_group.Project.name
    virtual_network_name = azurerm_virtual_network.Project-Network.name
    address_prefixes = ["10.1.1.0/24"]
}

resource "azurerm_network_interface" "public-ip" {
    name = "anything"
    location = "West Europe"
    resource_group_name = azurerm_resource_group.Project.name
    ip_configuration {
      name = "public-configuration"
      subnet_id = azurerm_subnet.Public-1.id
      private_ip_address_allocation = "static"
    }
}

resource "" "sshkey" {
  
}

resource "azurerm_linux_virtual_machine" "Bastion-Host" {
    name = "Bastion-Host"
    resource_group_name = azurerm_resource_group.Project.name
    location = "West Europe"
    network_interface_ids = [azurerm_network_interface.public-ip.id]
    size = "Standard_F2"    # Check price later
    admin_username = "TeamRocket"  # Use our team name

    admin_ssh_key {
      username = "TeamRocket"
      public_key = 
    }

    os_disk {
      caching = "ReadWrite"
    }
}






