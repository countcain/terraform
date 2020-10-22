provider "digitalocean" {
  token = var.digitalocean_token
}

resource "digitalocean_ssh_key" "terraform" {
  name       = "terraform public key"
  public_key = var.ssh_public_keys[0]
}

resource "digitalocean_ssh_key" "full_stack_panda" {
  name       = "my public key"
  public_key = var.ssh_public_keys[1]
}

resource "digitalocean_vpc" "project" {
  name     = "${var.region}-workstation"
  region = var.region
}

module "droplets-group-clients" {
  source = "./modules/droplets"

  pvt_key = var.pvt_key
  ssh_key_ids = [digitalocean_ssh_key.terraform.id, digitalocean_ssh_key.full_stack_panda.id]

  region = var.region
  amount_of = 3
  memory = 4096
  cpu = 2
  tags = ["nomad-clients", "kafka-brokers", var.region]
  vpc_id = digitalocean_vpc.project.id

  depends_on = [digitalocean_vpc.project]
}

module "droplets-group-servers" {
  source = "./modules/droplets"

  pvt_key = var.pvt_key
  ssh_key_ids = [digitalocean_ssh_key.terraform.id, digitalocean_ssh_key.full_stack_panda.id]

  region = var.region
  amount_of = 3
  memory = 1024
  cpu = 1
  tags = ["nomad-servers", var.region]
  vpc_id = digitalocean_vpc.project.id

  depends_on = [digitalocean_vpc.project]
}

resource "digitalocean_firewall" "general" {
  name     = "${var.region}-workstation-firewall"
  tags = [var.region]

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "udp"
    port_range       = "1194"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = [digitalocean_vpc.project.ip_range]
  }
  inbound_rule {
    protocol         = "udp"
    port_range       = "1-65535"
    source_addresses = [digitalocean_vpc.project.ip_range]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  depends_on = [digitalocean_vpc.project, module.droplets-group-clients, module.droplets-group-servers]
}
