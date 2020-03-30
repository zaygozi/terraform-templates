# Authenticating using Azure CLI
provider azurerm {
    version = "2.3.0"
    subscription_id = "Subscription_To_Use" #optional
    # a required block for azurerm 2.0.0 onwards
    features {
        virtual_machine {
            delete_os_disk_on_deletion = true #optional
        }
    }
}

# Creating Resource Group
resource azurerm_resource_group "rg" {
    name = "terraform-rg"
    location = "West Europe"
}

# Creating Virtual Network
resource azurerm_virtual_network "vnet" {
    name = "terraform-vnet"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space = ["10.1.0.0/16"]
}

# Creating Subnet 1
resource azurerm_subnet "sub1" {
    name = "terraform-sub-1"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix = "10.1.1.0/24"
}

# Creating Subnet 2
resource azurerm_subnet "sub2" {
    name = "terraform-sub-2"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix = "10.1.2.0/24"
}

# Creating a network security group for subnet 1
resource azurerm_network_security_group "nsg1" {
    name = "terraform-nsg"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    security_rule {
        name = "allow_ssh_from_anywhere"
        priority = "100"
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

# Associating subnet 1 with the network security group terraform-nsg
resource azurerm_subnet_network_security_group_association "subnet-nsg-association" {
    subnet_id = azurerm_subnet.sub1.id
    network_security_group_id = azurerm_network_security_group.nsg1.id
}

# Creating a network interface card for the virtual machine
resource azurerm_network_interface "nic" {
    name = "terraform-nic"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    # Ip Config
    ip_configuration {
        name = "terraform-ip-config"
        subnet_id = azurerm_subnet.sub1.id
        private_ip_address_allocation = "Dynamic"
    }
}

# Creating a linux virtual machine
resource azurerm_linux_virtual_machine "terraform-vm" {
    name = "terraform-vm"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    size = "Standard_B1s"
    # Setting an image (az vm image list)
    source_image_reference {
        offer = "UbuntuServer"
        publisher = "Canonical"
        sku = "18.04-LTS"
        version = "latest"
    }
    # OS Disk
    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
        disk_size_gb = "50"
    }
    # Authentication
    admin_username = "myuser"
    admin_ssh_key {
        username = "myuser"
        public_key = file("~/Documents/Terraform/Azure/vm-with-vnet/vm-key.pub") #absolute path
    }
    # Attaching the network interface
    network_interface_ids = [
        azurerm_network_interface.nic.id
    ]
}