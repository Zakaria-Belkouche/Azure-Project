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

resource "azurerm_public_ip" "bastion_ip" {
    name = "bastion-ip"
    resource_group_name = azurerm_resource_group.Project.name
    location = "West Europe"
    allocation_method = "Static"
}

resource "azurerm_network_security_group" "nsg" {
    name = "bastion-SG"
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
        source_address_prefix = "2.102.137.209"   # turn into a list and add team member IP's.
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "public_nic" {
    name = "bastion-nic"
    location = "West Europe"
    resource_group_name = azurerm_resource_group.Project.name
    ip_configuration {
      name = "public-configuration"
      subnet_id = azurerm_subnet.Public_1.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.bastion_ip.id
    }
}

resource "azurerm_network_interface_security_group_association" "bastion_nsg" {
    network_interface_id = azurerm_network_interface.public_nic.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "Bastion_Host" {
    name = "Bastion-Host"
    resource_group_name = azurerm_resource_group.Project.name
    location = "West Europe"
    network_interface_ids = [azurerm_network_interface.public_nic.id]
    size = "Standard_B1s"    # Very cheap. Good enough for a bastion host. ~ 0.0104/hr
    admin_username = "TeamName"  # Use our team name

    admin_ssh_key {
      username = "TeamName"
      public_key = file("./bastion-key.pub")        # Make ssh key manually on Azure
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


