resource "routeros_ip_firewall_nat" "ipv4_internet_access_firewall_nat_rule" {
  chain         = "srcnat"
  action        = "masquerade"
  out_interface = routeros_interface_ethernet.wan_interface_ether.name

}

resource "routeros_ip_firewall_filter" "ipv4_cctv_vlan_block_internet_access" {
  action = "drop"
  chain  = "forward"

  in_interface  = routeros_interface_vlan.cctv_vlan.name
  out_interface = routeros_interface_ethernet.wan_interface_ether.name

  comment = "Block internet access for Security Cameras VLAN"
}

resource "routeros_ip_firewall_filter" "ipv4_cctv_vlan_allow_dns_traffic" {
  action = "accept"
  chain  = "forward"

  dst_port = "53"

  in_interface  = routeros_interface_vlan.cctv_vlan.name
  out_interface = routeros_interface_ethernet.wan_interface_ether.name

  log      = true
  protocol = "udp"

  comment = "Allow DNS traffic for Security Cameras VLAN"
}

resource "routeros_ip_firewall_filter" "ipv4_cctv_vlan_allow_ntp_traffic" {
  action = "accept"
  chain  = "forward"

  dst_port = "123"

  in_interface  = routeros_interface_vlan.cctv_vlan.name
  out_interface = routeros_interface_ethernet.wan_interface_ether.name

  log      = true
  protocol = "udp"

  comment = "Allow NTP traffic for Security Cameras VLAN"
}

resource "routeros_ip_firewall_nat" "ipv4_ros_containers_allow_internet_access" {
  chain       = "srcnat"
  action      = "masquerade"
  src_address = "172.17.0.0/24"

}
