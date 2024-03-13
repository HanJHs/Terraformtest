resource "azurerm_resource_group" "main" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.vnet_address
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "vm-subnet" {
  name                 = var.vm_subnet_name
  address_prefixes     = var.vm_subnet_address
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
}

resource "azurerm_network_interface" "vm-nic" {
  name                = var.vm_nic_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_security_group" "vm-nsg" {
  name                = var.vm_nsg_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.vm-subnet.id
  network_security_group_id = azurerm_network_security_group.vm-nsg.id
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.vm_adminuser
  network_interface_ids = [azurerm_network_interface.vm-nic.id
disable_password_authentication = false
  admin_password = var.vm_adminpass


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
}
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_subnet" "psql-subnet" {
  name                 = var.psql_subnet_name
  address_prefixes     = var.psql_subnet_address
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
}


resource "azurerm_postgresql_server" "main" {
  name                = var.psql_server_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku_name = "GP_Gen5_4"
  version  = "11"

  storage_mb                   = 640000
  #backup_retention_days        = 7
  #geo_redundant_backup_enabled = false
  #auto_grow_enabled            = true

  administrator_login          = var.psql_server_admin_login
  administrator_login_password = var.psql_server_admin_login_password
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"

  public_network_access_enabled = true
  ssl_enforcement_enabled          = false
}

resource "azurerm_postgresql_database" "example" {
  name                = var.db_name
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.main.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

#start and end ip is "0.0.0.0" to allow access to azure services.
resource "azurerm_postgresql_firewall_rule" "example" {
  name                = "allow-azure-services"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}


resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

network_rules {
    default_action             = "Allow"
    virtual_network_subnet_ids = [azurerm_subnet.vm-subnet.id]
  }
}

resource "azurerm_storage_container" "example" {

  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}



