###################################
# Tag configuration for 
# Geo zone : France Central
# Not in disaster recovery datacenter
# Project : PRJ
# Budget : PRODUIT_A
# Resources with RGPD personal data
# No RGPD confidential data
# Environnement : Developpement
# Code repository : my_pet_project
###################################

module "aware_tagging" {
  source = "WeAreRetail/tags/azurerm"

  geozone           = "France Central"
  budget            = "PRODUIT_A"
  project           = "PRJ"
  rgpd_personal     = true
  rgpd_confidential = false
  disaster_recovery = false
  environment       = "DEV"
  repository        = "my_pet_project"
}

module "aware_naming" {
  source = "WeAreRetail/naming/azurerm"

  location    = "France Central"
  environment = "DEV"
  project     = "PRJ"
  area        = "master"
}

module "aware_resource_group" {
  source = "WeAreRetail/resource-group/azurerm"

  tags         = module.aware_tagging.tags
  location     = "France Central"
  description  = "My Resource-group"
  caf_prefixes = module.aware_naming.resource_group_prefixes
}

module "aware_virtual_network" {
  source = "WeAreRetail/virtual-network/azurerm"

  caf_prefixes        = module.aware_naming.resource_prefixes
  resource_group_name = module.aware_resource_group.name
  address_spaces      = ["10.0.0.0/16"]
  description         = "My VNet"
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = module.aware_resource_group.name
  virtual_network_name = module.aware_virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "aware_storage_account" {
  source = "weareretail/storage-account/azurerm"

  resource_group_name = module.aware_resource_group.name
  description         = "Test storage-account"
  caf_prefixes        = module.aware_naming.resource_prefixes
  instance_index      = 1
}

module "aware_private_dns_zone" {
  source = "WeAreRetail/private-dns-zone/azurerm"

  name                = "mydomain.com"
  resource_group_name = module.aware_resource_group.name
}

module "aware_private_endpoint" {
  source = "WeAreRetail/private-endpoint/azurerm"

  resource_group_name = module.aware_resource_group.name
  description         = "Test Private Endpoint"
  caf_prefixes        = module.aware_naming.resource_prefixes
  resource_id         = module.aware_storage_account.storage_account_id
  subnet_id           = azurerm_subnet.example.id
  subresource_names   = ["blob"]
}

