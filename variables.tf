variable "digitalocean_token" {
    description = "the digitalocean api token"
}

variable "ssh_public_keys" {
    description = "the public id_rsa.pub key used for secure SSH connections"
}

variable "pvt_key" {
    description = "terraform private key"
}
