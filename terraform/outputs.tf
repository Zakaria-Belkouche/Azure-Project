output "PublicVM_public_ip" {
  description = "The public IP address of the publicVM Host"
  value       = data.azurerm_public_ip.public-ip.ip_address
}