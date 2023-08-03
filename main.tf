locals {
  specific_tags = {
    "description" = var.description
  }

  location      = coalesce(var.custom_location, data.azurerm_resource_group.parent_group.location)
  parent_tags   = { for n, v in data.azurerm_resource_group.parent_group.tags : n => v if n != "description" }
  resource_name = coalesce(var.custom_name, azurecaf_name.self.result)
  tags          = { for n, v in merge(local.parent_tags, local.specific_tags, var.custom_tags) : n => v if v != "" }

  splitted_name        = split("/", var.resource_id)
  linked_resource_name = element(local.splitted_name, length(local.splitted_name) - 1)
}

data "azurerm_resource_group" "parent_group" {
  name = var.resource_group_name
}

resource "azurecaf_name" "self" {
  name          = var.subresource_names[0]
  resource_type = "azurerm_private_endpoint"
  prefixes      = var.caf_prefixes
  suffixes      = ["-", local.linked_resource_name]
  use_slug      = true
  clean_input   = true
  separator     = ""
}

resource "azurerm_private_endpoint" "this" {
  name                = azurecaf_name.self.result
  resource_group_name = data.azurerm_resource_group.parent_group.name
  location            = local.location
  subnet_id           = var.subnet_id
  tags                = local.tags

  private_service_connection {
    name                           = "${azurecaf_name.self.result}-privateserviceconnection"
    private_connection_resource_id = var.resource_id
    is_manual_connection           = false
    subresource_names              = var.subresource_names
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_group
    content {
      name                 = private_dns_zone_group.value["name"]
      private_dns_zone_ids = private_dns_zone_group.value["ids"]
    }
  }
}
