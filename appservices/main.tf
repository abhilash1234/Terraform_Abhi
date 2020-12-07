provider "azurerm" {
  features {}
}

#Azure appservices Module

resource "azurerm_app_service_plan" "int1" {
  name                         = var.appserviceplan_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_redis_cache" "cache" {
  name                = var.redis_cache_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 2
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = true
  minimum_tls_version = "1.2"

  redis_configuration {
    maxmemory_reserved = "50"
    maxfragmentationmemory_reserved = "50"
    maxmemory_policy = "volatile-lru"
    maxmemory_delta = "50"
  } 
}

resource "azurerm_app_service" "int1" {
  name                     = "myrep-web"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  app_service_plan_id      = azurerm_app_service_plan.int1.id
  https_only              = true

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "VSTSRM"
	default_documents  = ["Default.htm","Default.html","Default.asp","index.htm","index.html",
                    "iisstart.htm","default.aspx","index.php","hostingstart.html"]
  }

  app_settings = {
    "WEBSITE_HTTPLOGGING_RETENTION_DAYS" = "1"
    "WEBSITE_NODE_DEFAULT_VERSION" = "6.9.1"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appService-app_insights.instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION" = "1.0.0"
  }
  depends_on          = [azurerm_app_service_plan.int1]
}

resource "azurerm_application_insights" "appService-app_insights" {
  
  name                      =var.appinsitenameformyrepcenter
  resource_group_name      = var.resource_group_name
  location                 = var.location
  application_type          = "web" # Node.JS ,java
}



resource "azurerm_app_service" "int1api" {
  name                     = "api-Env-web"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  app_service_plan_id      = azurerm_app_service_plan.int1.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "VSTSRM"
    default_documents  = ["Default.htm","Default.html","Default.asp","index.htm","index.html",
                    "iisstart.htm","default.aspx","index.php","hostingstart.html"]
  }

  connection_string {
    name  = "Abp.Redis.Cache"
    type  = "Custom"
    value = azurerm_redis_cache.cache.primary_connection_string
  }

  app_settings = {
    "AccountLockoutSeconds" = "300"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appServiceapi_insights.instrumentation_key
    "PasswordExpiryDays" = "90"

  }

}
resource "azurerm_application_insights" "appServiceapi_insights" {
  
  name                      =var.appinsitenameforapi
  resource_group_name      = var.resource_group_name
  location                 = var.location
  application_type          = "web" # Node.JS ,java
}


resource "azurerm_app_service" "int1adminapi" {
  name                     = "Abc-Env-web"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  app_service_plan_id      = azurerm_app_service_plan.int1.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "VSTSRM"
    default_documents  = ["Default.htm","Default.html","Default.asp","index.htm","index.html",
                    "iisstart.htm","default.aspx","index.php","hostingstart.html"]
  }
  connection_string {
    name  = "Abp.Redis.Cache"
    type  = "Custom"
    value = azurerm_redis_cache.cache.primary_connection_string
  }

  app_settings = {
    "AccountLockoutSeconds" = "300"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appServiceadminapi_insights.instrumentation_k
  }

}
resource "azurerm_application_insights" "appServiceadminapi_insights" {
  
  name                      =var.appinsitenameforadminapi
  resource_group_name      = var.resource_group_name
  location                 = var.location
  application_type          = "web" # Node.JS ,java
}

