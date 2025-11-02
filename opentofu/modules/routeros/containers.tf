resource "routeros_container_config" "containers_config" {
  registry_url = "https://ghcr.io"
  ram_high     = "0"
  tmpdir       = "usb1-part1/containers/tmp"
  layer_dir    = "usb1-part1/containers/layers"
}
