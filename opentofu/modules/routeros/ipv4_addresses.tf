resource "routeros_ip_address" "management_vlan_cidr" {
  address   = "10.0.10.1/24"
  network   = "10.0.10.0"
  interface = routeros_interface_vlan.management_vlan.name

  comment = "Management VLAN"
}

resource "routeros_ip_address" "servers_vlan_cidr" {
  address   = "192.168.30.1/24"
  network   = "192.168.30.0"
  interface = routeros_interface_vlan.servers_vlan.name

  comment = "Servers VLAN"
}

resource "routeros_ip_address" "cctv_vlan_cidr" {
  address   = "10.0.50.1/24"
  network   = "10.0.50.0"
  interface = routeros_interface_vlan.cctv_vlan.name

  comment = "Security Cameras VLAN"
}

resource "routeros_ip_address" "living_room_tv_vlan_cidr" {
  address   = "192.168.88.1/30"
  network   = "192.168.88.0"
  interface = routeros_interface_vlan.living_room_tv_vlan.name

  comment = "Living Room TV VLAN"
}

resource "routeros_ip_address" "guests_cidr" {
  address   = "192.168.0.1/24"
  network   = "192.168.0.0"
  interface = routeros_interface_ethernet.lan_interface_ether.name

  comment = "Guest Devices"
}
