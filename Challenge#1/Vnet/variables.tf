variable "vnet_name" {
  description = "Name of the vnet to create."
  type        = string
  
}

variable "resource_group_name" {
  description = "The name of an existing resource group to be imported."
  type        = string
  
}

variable "vnet_gateway_suffix" {
  description = "Suffix to append to virtual network gateway name"
  
}

variable "location" {
  type        = string
}

variable "subscription_id" {
  type        = string
}

variable "tenant_id" {
  type        = string
}



variable "vnet_gateway_subnet_address_prefix" {
  type        = string
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = string
  
}

variable "Bastion_address_space" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "bastion_host_name" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "bastionipname" {
  description = "The address space that is used by the virtual network."
  type        = string
}

variable "storage_account_name" {
  description = "Storage Account name."
  type        = string
}

variable "sqlservername" {
  description = "SQL Server Name."
  type        = string
}
variable "sqladminusername" {
  description = "SQL Server admin Login id."
  type        = string
}
variable "sqladminpass" {
  description = "SQL Server admin Login password."
  type        = string
}

variable "networkinterfacename" {
  description = "Network interface for VM."
  type        = string
}

variable "VMName" {
  description = "VM Name."
  type        = string
}




# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  type        = list(string)
  
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  
}


variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {
    environment = "env"
  }
}