output "group-clients-public-ip-addresses" {
  value = [module.droplets-group-clients.digitalocean_droplet_public_ip_addresses]
}
output "group-clients-private-ip-addresses" {
  value = [module.droplets-group-clients.digitalocean_droplet_private_ip_addresses]
}

output "group-servers-public-ip-addresses" {
  value = [module.droplets-group-servers.digitalocean_droplet_public_ip_addresses]
}
output "group-servers-private-ip-addresses" {
  value = [module.droplets-group-servers.digitalocean_droplet_private_ip_addresses]
}