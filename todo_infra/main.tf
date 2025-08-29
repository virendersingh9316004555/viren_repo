module "resource_group" {
  source                  = "../modules/azurerm_resource_group"
  resource_group_name     = "rg_duggu"
  resource_group_location = "West US"
}

module "resource_group1" {
  source                  = "../modules/azurerm_resource_group"
  resource_group_name     = "rg_duggu1"
  resource_group_location = "West US"
}

module "virtual_network" {
  depends_on               = [module.resource_group]
  source                   = "../modules/azurerm_virtual_network"
  virtual_network_name     = "vnet_duggu"
  virtual_network_location = "West US"
  resource_group_name      = "rg_duggu"
  address_space            = ["10.0.0.0/22"]
}

module "frontend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../modules/azurerm_subnet"
  subnet_name          = "f_subnet_duggu"
  resource_group_name  = "rg_duggu"
  virtual_network_name = "vnet_duggu"
  address_prefixes     = ["10.0.1.0/24"]

}

module "backend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../modules/azurerm_subnet"
  subnet_name          = "b_subnet_duggu"
  resource_group_name  = "rg_duggu"
  virtual_network_name = "vnet_duggu"
  address_prefixes     = ["10.0.2.0/24"]

}

module "azurerm_front_pip" {

  source              = "../modules/azurerm_public_ip"
  pip_name            = "f_pip_duggu"
  resource_group_name = "rg_duggu"
  location            = "West US"
  allocation_method   = "Static"
  sku_name = "Basic"
}

module "azurerm_backend_pip" {

  source              = "../modules/azurerm_public_ip"
  pip_name            = "b_pip_duggu"
  resource_group_name = "rg_duggu"
  location            = "West US"
  allocation_method   = "Static"
  sku_name = "Basic"
}

module "azurerm_frontend_pip1" {

  source              = "../modules/azurerm_public_ip"
  pip_name            = "f_pip_duggu1"
  resource_group_name = "rg_duggu"
  location            = "West US"
  allocation_method   = "Static"
  sku_name =   "Basic"
}

module "azurerm_vm1" {
  depends_on = [module.virtual_network]
  source     = "../modules/azurerm_virtual_machine"

  vm_name              = "frontenddugguvm"
  resource_group_name  = "rg_duggu"
  location             = "West US"
  vm_size              = "Standard_B1s"
  admin_username       = "frontenddugguadmin"
  admin_password       = "test1234@#"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-jammy"
  image_sku            = "22_04-lts-gen2"
  image_version        = "latest"
  pip_name             = "f_pip_duggu"
  subnet_name          = "f_subnet_duggu"
  virtual_network_name = "vnet_duggu"
  nic_name             = "frontend_duggu_nic"

}

module "azurerm_vm2" {
  depends_on = [module.virtual_network]
  source     = "../modules/azurerm_virtual_machine"

  vm_name              = "backenddugguvm"
  resource_group_name  = "rg_duggu"
  location             = "West US"
  vm_size              = "Standard_B1s"
  admin_username       = "backenddugguadmin"
  admin_password       = "test1234@#"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-jammy"
  image_sku            = "22_04-lts-gen2"
  image_version        = "latest"
  pip_name             = "b_pip_duggu"
  subnet_name          = "b_subnet_duggu"
  virtual_network_name = "vnet_duggu"
  nic_name             = "backend_duggu_nic"

}

module "azurerm_vm3" {
  depends_on = [module.virtual_network , module.azurerm_frontend_pip1]
  source     = "../modules/azurerm_virtual_machine"

  vm_name              = "backenddugguvm"
  resource_group_name  = "rg_duggu"
  location             = "West US"
  vm_size              = "Standard_B1s"
  admin_username       = "backenddugguadmin"
  admin_password       = "test1234@#"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-jammy"
  image_sku            = "22_04-lts-gen2"
  image_version        = "latest"
  pip_name             = "f_pip_duggu1"
  subnet_name          = "b_subnet_duggu"
  virtual_network_name = "vnet_duggu"
  nic_name             = "frontend_duggu_nic1"
}

module "sql_server" {
  source              = "../modules/azurerm_sql_server"
  sql_server_name     = "duggusqlserver"
  resource_group_name = "rg_duggu"
  location            = "West US"
  mssql_version       = "12.0"
  sql_admin_login     = "sqladmin"
  sql_admin_password  = "test1234@#"
}

module "sql_database" {
  depends_on = [ module.sql_server ]

  source              = "../modules/azurerm_sql_database"
  sql_database_name   = "duggusqldb"
  resource_group_name = "rg_duggu"
  sql_server_name     = "duggusqlserver"

}


