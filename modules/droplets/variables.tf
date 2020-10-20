variable "region" {
  type    = string
  description = "the region of digitalocean droplets"
}

variable "amount_of" {
  type    = number
  description = "the amount of droplets"
}

variable "ssh_key_ids" {
  type    = list(number)
  description = "the public id_rsa.pub key used for secure SSH connections"
}

variable "pvt_key" {
  type    = string
  description = "terraform private key to connect to droplets"
}

variable "memory" {
  type    = number
  description = "droplet memory requirement"
}

variable "cpu" {
  type    = number
  description = "droplet cpu amount"
}

variable "tags" {
  type    = list(string)
  description = "tags added to the droplet"
}
