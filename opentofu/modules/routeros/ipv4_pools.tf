resource "routeros_ip_pool" "guests_dhcp_pool" {
  name   = "dhcp-guests-pool"
  ranges = ["192.168.0.2-192.168.0.254"]

}

resource "routeros_ip_pool" "vlan10_dhcp_pool" {
  name   = "dhcp-vlan10-pool"
  ranges = ["10.0.10.2-10.0.10.254"]

}

resource "routeros_ip_pool" "vlan30_dhcp_pool" {
  name   = "dhcp-vlan30-pool"
  ranges = ["192.168.30.2-192.168.30.254"]

}

resource "routeros_ip_pool" "vlan50_dhcp_pool" {
  name   = "dhcp-vlan50-pool"
  ranges = ["10.0.50.2-10.0.50.254"]

}

resource "routeros_ip_pool" "vlan60_dhcp_pool" {
  name   = "dhcp-vlan60-pool"
  ranges = ["192.168.88.2"]

}
