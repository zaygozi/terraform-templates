# Authenticating using Azure CLI
provider azurerm {
    version = "2.3.0"
    subscription_id = "Subscription_To_Use" #optional
    features {} # a required block for azurerm 2.0.0 onwards
}

# Creating Resource Group
resource azurerm_resource_group "rg" {
    name = "terraform-rg"
    location = "West Europe"
}

# Creating Storage Account Within The Resource Group
resource azurerm_storage_account "zaygo-terraform-storage" {
    name = "terraform69"
    resource_group_name = azurerm_resource_group.rg.name
    location = "North Europe"
    account_kind = "StorageV2"
    account_tier = "Standard"
    access_tier = "Hot"
    account_replication_type = "LRS"
    # Tags
    tags = {
        "Created By" = "Terraform"
    }
}

# Creating A Container Within The Storage Account
resource azurerm_storage_container "terraform-container" {
    name = "terraform-container"
    storage_account_name = azurerm_storage_account.zaygo-terraform-storage.name
}