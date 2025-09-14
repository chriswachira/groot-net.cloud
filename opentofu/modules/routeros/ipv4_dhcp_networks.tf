resource "routeros_ip_dhcp_server_network" "vlan10_dhcp_server_network" {
  address    = "10.0.10.0/24"
  gateway    = "10.0.10.1"
  dns_server = ["10.0.10.1"]
}

resource "routeros_ip_dhcp_server_network" "guests_dhcp_server_network" {
  address    = "192.168.0.0/24"
  gateway    = "192.168.0.1"
  dns_server = ["192.168.0.1"]
}
