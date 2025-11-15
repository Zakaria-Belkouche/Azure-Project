resource "azurerm_resource_group" "Project" {
    name = "Project-Directory"
    location = "West Europe"
}

resource "azurerm_virtual_network" "Project_Network" {
    name = "Project-Network"
    resource_group_name = azurerm_resource_group.Project.name
    location = "West Europe"
    address_space = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "Public_1" {
    name = "Public-1"
    resource_group_name = azurerm_resource_group.Project.name
    virtual_network_name = azurerm_virtual_network.Project_Network.name
    address_prefixes = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "Private_1" {
    name = "Private-1"
    resource_group_name = azurerm_resource_group.Project.name
    virtual_network_name = azurerm_virtual_network.Project_Network.name
    address_prefixes = ["10.1.1.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
    name = "public-ip"
    resource_group_name = azurerm_resource_group.Project.name
    location = "West Europe"
    allocation_method = "Static"
}

resource "azurerm_network_security_group" "public_nsg" {
    name = "PublicVM-SG"
    resource_group_name = azurerm_resource_group.Project.name
    location = "West Europe"
    security_rule {
        name = "dev-team-access"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefixes = var.Team_IPs   # turn into a list and add team member IP's.
        destination_address_prefix = "*"
    }

    # intenet access

    security_rule {
        name = "internet-access"
        priority = 200
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "80"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "prometheus-ui"
        priority                   = 210
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "9090"
        source_address_prefixes    = var.Team_IPs
        destination_address_prefix = "*"
  }
 
    security_rule {
        name                       = "grafana-ui"
        priority                   = 220
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3000"
        source_address_prefixes    = var.Team_IPs
        destination_address_prefix = "*"
  }

}

resource "azurerm_network_interface" "public_nic" {
    name = "PublicVM-nic"
    location = "West Europe"
    resource_group_name = azurerm_resource_group.Project.name
    ip_configuration {
      name = "public-configuration"
      subnet_id = azurerm_subnet.Public_1.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.public_ip.id
    }
}

resource "azurerm_network_interface_security_group_association" "public_assosiation" {
    network_interface_id = azurerm_network_interface.public_nic.id
    network_security_group_id = azurerm_network_security_group.public_nsg.id
}

resource "azurerm_linux_virtual_machine" "public_vm" {
    name = "public-vm"
    resource_group_name = azurerm_resource_group.Project.name
    location = "West Europe"
    network_interface_ids = [azurerm_network_interface.public_nic.id]
    size = "Standard_B1s"    # Very cheap. ~ 0.0104/hr. Might need a bigger one
    admin_username = "CodeMagicians"  # Use our team name

    admin_ssh_key {
      username = "CodeMagicians"
      public_key = file("../keys/publicVM-key.pub")        # Can make ssh key manually on Azure
    }                                               # then make data block to refer to it. (for future)

    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference {
      publisher = "Canonical"  # = Ubuntu
      offer = "0001-com-ubuntu-server-jammy"
      sku = "22_04-lts"
      version = "latest"
    }
}


