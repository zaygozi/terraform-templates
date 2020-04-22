# WE define the resources that are imported into the state in this file

# Importing key vault resource (remember to run terraform import)
resource azurerm_key_vault "key-vault" {
    name = "keyvault"
    location = "east us"
    resource_group_name = "RG"
    sku_name = "standard"
    tenant_id = "Tenant-Id"
}