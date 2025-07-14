variable "description" {
  type        = string
  default     = ""
  description = "Resource description."
}

variable "caf_prefixes" {
  type        = list(string)
  default     = []
  description = "Prefixes to use for caf naming."
}

variable "resource_group_name" {
  type        = string
  description = "Specifies the Name of the Resource Group within which the Private Endpoint should exist. Changing this forces a new resource to be created."
}

variable "resource_id" {
  type        = string
  description = "The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created."
}

variable "subresource_names" {
  type        = list(string)
  description = "A list of subresource names which the Private Endpoint is able to connect to. subresource_names corresponds to group_id. Changing this forces a new resource to be created."
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "The custom tags to add on the resource."
}

variable "custom_location" {
  type        = string
  default     = ""
  description = "Specifies a custom location for the resource."
}

variable "custom_name" {
  type        = string
  default     = ""
  description = "Specifies a custom name for the resource."
}

variable "private_dns_zone_group" {
  type = list(
    object({
      name = string
      ids  = list(string)
    })
  )
  default     = null
  description = "The private DNS zone groupe. Example {name = \"default\", ids = [\"azurerm_private_dns_zone.private_dns_zones.id\"]}"
}

variable "ip_configuration" {
  type = object({
    name               = optional(string)
    private_ip_address = optional(string)
    subresource_name   = optional(string)
    member_name        = optional(string)
  })
  default = null
  description = "This allows a static IP address to be set for this Private Endpoint, otherwise an address is dynamically allocated from the Subnet."
}