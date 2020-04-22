# In this template we will configure a vm using username and password stored in a key vault
# As the key vault already exists and is not created or managed by terraform, you will need to run the `terraform import` command to import that resource

# Authenticating using Azure CLI
provider azurerm {
    version = "2.3.0"
    subscription_id = "Subscription-Id" #optional
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

# Creating a subnet
resource azurerm_subnet "sub1" {
    name = "terraform-sub-1"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix = "10.1.1.0/24"
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

# Creating data sources for the key vault secrets. They act like variables holding secrets
data azurerm_key_vault_secret "vm-username" {
    name = "vm-username"
    key_vault_id = var.keyvault-id
}
data azurerm_key_vault_secret "vm-password" {
    name = "vm-password"
    key_vault_id = var.keyvault-id
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
    disable_password_authentication = false #required to ssh using username/password
    admin_username = data.azurerm_key_vault_secret.vm-username.value
    admin_password = data.azurerm_key_vault_secret.vm-password.value
    # Attaching the network interface
    network_interface_ids = [
        azurerm_network_interface.nic.id
    ]
}