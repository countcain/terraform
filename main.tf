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

module "droplets" {
  source = "./modules/droplets"

  pvt_key = var.pvt_key
  ssh_key_ids = [digitalocean_ssh_key.terraform.id, digitalocean_ssh_key.full_stack_panda.id]

  region = "sfo2"
  amount_of = 3
  memory = 4096
  cpu = 2
  tags = ["kafka-cluster"]
}