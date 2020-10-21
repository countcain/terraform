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

resource "digitalocean_droplet" "nodes" {
  count = var.amount_of
  region = var.region
  name = "${var.region}-${var.tags[0]}-${count.index}"
  image = "ubuntu-20-04-x64"
  size = element(data.digitalocean_sizes.main.sizes, 0).slug
  monitoring = true
  vpc_uuid = var.vpc_id
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
      "sleep 30s",
      "apt update -y",
      "apt upgrade -y",
      "apt install -y software-properties-common",
      "apt install -y ansible"
    ]
  }
}
