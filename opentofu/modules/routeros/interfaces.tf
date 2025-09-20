resource "routeros_interface_ethernet" "wan_interface_ether" {
  factory_name = "ether1"
  name         = "wan"
  mtu          = 1500

  comment = "Safaricom FTTH"
}

resource "routeros_interface_ethernet" "lan_interface_ether" {
  factory_name = "sfp1"
  name         = "sfp-lan"
  mtu          = 1500

  comment = "Home LAN"
}

resource "routeros_interface_vlan" "management_vlan" {
  name      = "vlan10-management"
  vlan_id   = 10
  interface = routeros_interface_ethernet.lan_interface_ether.name

  comment = "MAC-based VLAN for network management."
  mtu     = 1500
}

resource "routeros_interface_vlan" "servers_vlan" {
  name      = "vlan30-servers"
  vlan_id   = 30
  interface = routeros_interface_ethernet.lan_interface_ether.name

  comment = "Port-based VLAN for home servers."
  mtu     = 1500
}

resource "routeros_interface_vlan" "cctv_vlan" {
  name      = "vlan50-cctv"
  vlan_id   = 50
  interface = routeros_interface_ethernet.lan_interface_ether.name

  comment = "Port-based VLAN for security cameras."
  mtu     = 1500
}

resource "routeros_interface_vlan" "living_room_tv_vlan" {
  name      = "vlan60-tv"
  vlan_id   = 60
  interface = routeros_interface_ethernet.lan_interface_ether.name

  comment = " MAC-based VLAN for home TV."
  mtu     = 1500
}

resource "routeros_interface_veth" "containers_veth" {
  name    = "veth-containers"
  address = ["172.17.0.2/24"]
  gateway = "172.17.0.1"

  comment = "Virtual ethernet interface for RouterOS containers"
}
