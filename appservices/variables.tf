variable "location" {
  type        = string
}

variable "subscription_id" {
  type        = string
}

variable "tenant_id" {
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "appserviceplan_name" {
  type        = string
}

variable "appinsitenameformyrepcenter" {
  type        = string
}

variable "appinsitenameforapi" {
  type        = string
}

variable "appinsitenameforadminapi" {
  type        = string
}

variable "redis_cache_name" {
  description = "Name of redis cache name."
  type        = string
}
