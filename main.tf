module "Vnet" {
    source = "./Vnet"
    subscription_id = "XXXXXXX"
    tenant_id = "YYYYY"
    resource_group_name ="env-rg"
    location = "eastus"
    vnet_name = "env-vn"
    address_space = "10.25.0.0/16"
    dns_servers = ["168.63.129.16"]
    subnet_prefixes = ["10.25.1.0/24","10.25.2.0/24"]
    subnet_names = ["backend-int1","frontend-int1"]
    vnet_gateway_subnet_address_prefix = "10.25.255.0/27"
    bastion_host_name ="env-vn-bastion"
    Bastion_address_space = "10.25.3.224/27"
    bastionipname = "env-vn-bastion-ip"
    storage_account_name = "envstorage"
    sqlservername   = "env-sql"
    sqladminusername = "envadmin"
    sqladminpass  = "@dmin@envE1@"
    networkinterfacename = "env-vm-nic"
    VMName = "EM-vm"
}

module "appservices" {
    source = "./appservices"
    subscription_id = "XXXXXXX"
    tenant_id = "YYYYY"
    resource_group_name ="env-rg"
    location = "eastus"
    appserviceplan_name = "env-asp"
    appinsitenameformyrepcenter = "env-web"
    appinsitenameforapi = "api-env-web"
    appinsitenameforadminapi = "adminapi-env-web"
    redis_cache_name = "api-env-cache"

}
