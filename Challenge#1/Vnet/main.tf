#Azure vNet Module
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "env" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [var.address_space]
  dns_servers         = var.dns_servers
  tags                = var.tags
  depends_on          = [azurerm_resource_group.env]
}

resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = var.resource_group_name
  address_prefixes     = [var.subnet_prefixes[count.index]]
  virtual_network_name = azurerm_virtual_network.vnet.name
  depends_on          = [azurerm_resource_group.env,azurerm_virtual_network.vnet]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.Bastion_address_space]
  depends_on          = [azurerm_resource_group.env,azurerm_virtual_network.vnet]
}

resource "azurerm_subnet" "gateway" {

  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  address_prefixes     = [var.vnet_gateway_subnet_address_prefix]
  virtual_network_name = var.vnet_name
  depends_on          = [azurerm_resource_group.env,azurerm_virtual_network.vnet]
}

resource "azurerm_public_ip" "example" {
  name                = var.bastionipname
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on          = [azurerm_resource_group.env]
}

resource "azurerm_bastion_host" "example" {
  name                = var.bastion_host_name
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.example.id
  }
  depends_on          = [azurerm_resource_group.env,azurerm_virtual_network.vnet]
}

resource "azurerm_storage_account" "env" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  depends_on          = [azurerm_resource_group.env]
}


resource "azurerm_sql_server" "example" {
  name                         = var.sqlservername
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sqladminusername
  administrator_login_password = var.sqladminpass

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.env.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.env.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
  depends_on          = [azurerm_resource_group.env,azurerm_virtual_network.vnet]
}

resource "azurerm_sql_database" "host" {
  name                         = "env-host-env-db"
  resource_group_name          = azurerm_resource_group.env.name
  location                     = var.location
  server_name                  = azurerm_sql_server.example.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.env.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.env.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
  tags = {
    environment = "env"
  }
}

resource "azurerm_sql_database" "etl" {
  name                         = "env-etl-env-db"
  resource_group_name          = azurerm_resource_group.env.name
  location                     = var.location
  server_name                  = azurerm_sql_server.example.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.env.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.env.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }

  tags = {
    environment = "env"
  }
}

resource "azurerm_network_interface" "example" {
  name                     = var.networkinterfacename
  resource_group_name      = var.resource_group_name
  location                 = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet[1].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                     = var.VMName
  resource_group_name      = var.resource_group_name
  location                 = var.location
  size                = "Standard_DS11_v2"
  admin_username      = "admin"
  admin_password      = "oj$Y;eFy^U8"
  
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}