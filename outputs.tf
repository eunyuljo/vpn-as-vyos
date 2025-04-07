output "vyos_eip_address" {
  value = aws_eip.vyos_eip.public_ip
  description = "The public IP address of the VyOS instance."
}