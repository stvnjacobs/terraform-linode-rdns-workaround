variable "domain" {
  type = string
}

variable "wait_for" {
  type = string
  default = "10m"
}

data "linode_domain" "example" {
  domain = var.domain
}

resource "random_pet" "server" {
  keepers = {
    domain_id = data.linode_domain.example.id
  }
}

resource "linode_instance" "example" {
  label  = "example-${random_pet.server.id}"
  image  = "linode/alpine3.15"
  type   = "g6-nanode-1"
  region = "ca-central"
}

resource "linode_domain_record" "example" {
  domain_id = data.linode_domain.example.id

  name        = "example-${random_pet.server.id}"
  target      = linode_instance.example.ip_address
  record_type = "A"
}

resource "time_sleep" "domain_propagation" {
  triggers = {
    name   = linode_instance.example.label
    target = linode_instance.example.ip_address
  }

  create_duration = var.wait_for
}

resource "linode_rdns" "example" {
  depends_on = [time_sleep.domain_propagation]

  address = linode_instance.example.ip_address
  rdns    = "example-${random_pet.server.id}.${data.linode_domain.example.domain}"
}
