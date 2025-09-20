resource "routeros_interface_bridge" "containers_bridge" {
  name    = "br-containers"
  comment = "Bridge for running containers on RouterOS"
}

resource "routeros_bridge_port" "containers_veth_bridge_port" {
  bridge    = routeros_interface_bridge.containers_bridge.name
  interface = routeros_interface_veth.containers_veth.name

  comment = "Bridge port for RouterOS containers virtual ethernet interface"
}
