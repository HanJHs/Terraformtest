variable "rg_name" {
  description = "Name of the resource group"
  type        = string
  default = "rgname"
}

variable "rg_location" {
  description = "Location of the resource group"
  type        = string
  default = "southeastasia"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default = "vnetname"
}


variable "vnet_address" {
  description = "Address list of the virtual network"
  type        = list(string)
  default = ["10.0.0.0/16"]
}


variable "vm_subnet_name" {
  description = "Name of the VM subnet"
  type        = string
  default = "vm-subnet"
}

variable "vm_subnet_address"{
  description = "Address list of VM subnet"
  type        = list(string)
  default = ["10.0.1.0/24"]
}
variable "vm_nic_name" {
  description = "Name of the NIC attached to vm-subnet"
  type        = string
  default = "vm-nic"
}
variable "vm_nsg_name" {
  description = "Name of the nsg"
  type        = string
  default = "vm-nsg"
}


variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default = "vmname"
}


variable "vm_adminuser" {
  description = "Admin username of the virtual machine"
  type        = string
  default = "azureuser"
}


variable "vm_adminpass" {
  description = "Password of admin username of the virtual machine"
  type        = string
  default = "Mynameis1234"
  sensitive = true
}



variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default = "Standard_B2s"
}

variable "psql_subnet_name" {
  description = "Name of psql subnet"
  type        = string
  default = "psql-subnet"
}
variable "psql_subnet_address" {
  description = "address of psql subnet"
  type        = list(string)
  default = ["10.0.2.0/24"]
}


variable "psql_server_name" {
  description = "Name of the psql server"
  type        = string
  default = "psqlserver12345"
}


variable "psql_server_admin_login" {
  description = "admin login user of the psql server"
  type        = string
  default = "psqladmin"
}

variable "psql_server_admin_login_password" {
  description = "Password of admin login user of the psql server"
  type        = string
  default = "Mynameis1234"
  sensitive = true
}


variable "db_name" {
  description = "Name of the database"
  type        = string
  default = "exampledb"
}
variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
  default = "terrastore12345"
}


variable "storage_container_name" {
  description = "Name of the storage container"
  type        = string
  default = "content"
}

