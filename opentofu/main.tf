module "routeros" {
  source = "./modules/routeros"

  router_host_url = "http://192.168.0.1"
  router_username = "rest-client"
  router_password = "wamlambez"
}
