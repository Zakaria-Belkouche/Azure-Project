output "bastion_public_ip" {
  description = "The public IP address of the Bastion Host"
  value = azurerm_public_ip.bastion_ip.ip_address
}