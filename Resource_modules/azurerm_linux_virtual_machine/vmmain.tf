data "azurerm_subnet" "datasubnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
}

data "azurerm_public_ip" "datapip" {
  name                = var.public_ip
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault" "datakeyvault" {
  name                = "kv-infraautomation89"
  resource_group_name = "keyvault_rg"
}

data "azurerm_key_vault_secret" "datasecretusername" {
  name         = "vm-username"
  key_vault_id = data.azurerm_key_vault.datakeyvault.id 
}

data "azurerm_key_vault_secret" "datasecretpassword" {
  name         = "vm-password"
  key_vault_id = data.azurerm_key_vault.datakeyvault.id 
}


resource "azurerm_network_interface" "practice1_nic" {
  name                = var.network_interface_card
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     =  data.azurerm_subnet.datasubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          =  data.azurerm_public_ip.datapip.id
  }
}


resource "azurerm_linux_virtual_machine" "vm1name" {
  name                            = var.virtual_machine_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = data.azurerm_key_vault_secret.datasecretusername.value
  admin_password                  = data.azurerm_key_vault_secret.datasecretpassword.value
  disable_password_authentication = var.disable_password_authentication
  network_interface_ids = [
    azurerm_network_interface.practice1_nic.id
  ]

  os_disk {
    caching              = var.caching
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }
}