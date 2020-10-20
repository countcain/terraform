output "digitalocean_droplet_public_ip" {
  value = [digitalocean_droplet.nodes.*.ipv4_address]
}

output "digitalocean_droplet_private_ip" {
  value = [digitalocean_droplet.nodes.*.ipv4_address_private]
}
