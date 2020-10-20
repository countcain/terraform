data "digitalocean_sizes" "main" {
  filter {
    key    = "regions"
    values = [var.region]
  }

  filter {
    key    = "vcpus"
    values = [var.cpu]
  }

  filter {
    key    = "memory"
    values = [var.memory]
  }

  sort {
    key       = "price_monthly"
    direction = "asc"
  }
}

resource "digitalocean_vpc" "project" {
  name     = "${var.region}-${var.tags[0]}"
  region = var.region
}

resource "digitalocean_droplet" "nodes" {
  count = var.amount_of
  region = var.region
  name = "${var.region}-${var.tags[0]}-${count.index}"
  image = "ubuntu-20-04-x64"
  size = element(data.digitalocean_sizes.main.sizes, 0).slug
  monitoring = true
  vpc_uuid = digitalocean_vpc.project.id
  private_networking = true
  ssh_keys = var.ssh_key_ids
  tags = var.tags

  connection {
    type     = "ssh"
    user     = "root"
    private_key = var.pvt_key
    host     = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 10s",
      "apt update",
      "apt install -y software-properties-common",
      "apt-add-repository --yes --update ppa:ansible/ansible",
      "apt install -y ansible"
    ]
  }

  depends_on = [digitalocean_vpc.project]
}

resource "digitalocean_firewall" "general" {
  name = "${var.region}-${var.tags[0]}"
  droplet_ids = digitalocean_droplet.nodes.*.id

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "icmp"
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

  depends_on = [digitalocean_droplet.nodes]
}