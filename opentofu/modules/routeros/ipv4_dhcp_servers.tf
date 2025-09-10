resource "routeros_ip_dhcp_server" "management_vlan_dhcp_server" {
  name         = "dhcp-vlan10-management"
  interface    = routeros_interface_vlan.management_vlan.name
  address_pool = routeros_ip_pool.vlan10_dhcp_pool.name

}

resource "routeros_ip_dhcp_server" "servers_vlan_dhcp_server" {
  name         = "dhcp-vlan30-servers"
  interface    = routeros_interface_vlan.servers_vlan.name
  address_pool = routeros_ip_pool.vlan30_dhcp_pool.name

}

resource "routeros_ip_dhcp_server" "cctv_vlan_dhcp_server" {
  name         = "dhcp-vlan50-cctv"
  interface    = routeros_interface_vlan.cctv_vlan.name
  address_pool = routeros_ip_pool.vlan50_dhcp_pool.name

}

resource "routeros_ip_dhcp_server" "living_room_tv_vlan_dhcp_server" {
  name         = "dhcp-vlan60-tv"
  interface    = routeros_interface_vlan.living_room_tv_vlan.name
  address_pool = routeros_ip_pool.vlan60_dhcp_pool.name

}

resource "routeros_ip_dhcp_server" "guests_dhcp_server" {
  name         = "dhcp-guests"
  interface    = routeros_interface_ethernet.lan_interface_ether.name
  address_pool = routeros_ip_pool.guests_dhcp_pool.name

}