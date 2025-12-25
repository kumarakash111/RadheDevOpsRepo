module "rg1test" {
  source              = "../../Resource_modules/azurerm_resource_group"
  resource_group_name = "rginfra-test"
  location            = "East US"
}

module "vnet1test" {
  depends_on           = [module.rg1test]
  source               = "../../Resource_modules/azurerm_virtual_network"
  virtual_network_name = "vnet-infra-test"
  address_space        = ["10.0.0.0/16"]
  location             = "East US"
  resource_group_name  = "rginfra-test"
}

module "subnet1test" {
  depends_on           = [module.vnet1test]
  source               = "../../Resource_modules/azurerm_subnet"
  subnet_name          = "subnet-infra-test"
  resource_group_name  = "rginfra-test"
  virtual_network_name = "vnet-infra-test"
  address_prefixes     = ["10.0.1.0/24"]
}

module "pip" {
  depends_on          = [module.rg1test]
  source              = "../../Resource_modules/azurerm_public_ip"
  public_ip           = "pip-infra-test"
  location            = "East US"
  resource_group_name = "rginfra-test"
  allocation_method   = "Static"
  sku                 = "Standard"
}

module "virtual_machine1test" {
  depends_on                      = [module.rg1test, module.pip, module.subnet1test]
  source                          = "../../Resource_modules/azurerm_linux_virtual_machine"
  network_interface_card          = "nic-infra-test"
  location                        = "East US"
  resource_group_name             = "rginfra-test"
  virtual_machine_name            = "vm-infra-test"
  size                            = "Standard_B1ms"
  disable_password_authentication = false
  caching                         = "ReadWrite"
  storage_account_type            = "Standard_LRS"
  publisher                       = "Canonical"
  offer                           = "UbuntuServer"
  sku                             = "18.04-LTS"
  subnet_name                     = "subnet-infra-test"
  virtual_network_name            = "vnet-infra-test"
  public_ip                       = "pip-infra-test"
  key_vault_name                  = "kv-infraautomation89"

}
