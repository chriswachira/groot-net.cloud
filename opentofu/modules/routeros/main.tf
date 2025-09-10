terraform {
  required_providers {
    routeros = {
      source = "terraform-routeros/routeros"
    }
  }
}

provider "routeros" {
  hosturl  = var.router_host_url
  username = var.router_username
  password = var.router_password
  insecure = true
}
