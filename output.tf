# outputs
output "private_ip" {
  value       = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
  description = "Endpoint private IP in the subnet."
}

output "linked_resource_name" {
  value       = local.linked_resource_name
  description = "Azure name of the private resource."
}
