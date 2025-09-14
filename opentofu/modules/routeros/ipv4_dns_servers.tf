resource "routeros_ip_dns" "dns_server" {
  allow_remote_requests = true
  servers               = ["8.8.8.8", "1.1.1.1"]
}
