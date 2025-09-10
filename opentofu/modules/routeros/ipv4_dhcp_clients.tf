resource "routeros_ip_dhcp_client" "wan_dhcp_client" {
  interface = routeros_interface_ethernet.wan_interface_ether.name

  add_default_route = "yes"
  use_peer_dns      = true
  use_peer_ntp      = true

  comment = "Safaricom FTTH Router DHCP client"
}
