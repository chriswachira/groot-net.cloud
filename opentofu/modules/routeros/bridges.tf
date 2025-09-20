resource "routeros_interface_bridge" "containers_bridge" {
  name    = "br-containers"
  comment = "Bridge for running containers on RouterOS"
}
