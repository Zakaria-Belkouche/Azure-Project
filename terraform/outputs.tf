output "PublicVM_public_ip" {
  description = "The public IP address of the publicVM Host"
  value = azurerm_public_ip.public_ip.ip_address
}