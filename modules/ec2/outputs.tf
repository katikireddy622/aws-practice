output "apache2-public-instance-private-ip" {
  value = aws_instance.apache2-instance.private_ip
}

output "apache2-public-instance-public-ip" {
  value = aws_instance.apache2-instance.public_ip
}

output "apache2-private-instance-private-ip" {
  value = aws_instance.apache2-instance-private.private_ip
}

output "apache2-private-instance-public-ip" {
  value = aws_instance.apache2-instance-private.public_ip
}

output "nat_gateway_ip" {
  value = aws_eip.nat_gateway_eip.public_ip
}

output "ssh_private_key_pem" {
  sensitive = true
  value = tls_private_key.ssh.private_key_pem
}

output "ssh_public_key_pem" {
  sensitive = true
  value = tls_private_key.ssh.public_key_pem
}