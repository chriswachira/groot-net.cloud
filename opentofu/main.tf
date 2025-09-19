module "aws" {
  source                                         = "./modules/aws"
  groot_net_teleport_cluster_admin_email_address = var.groot_net_teleport_cluster_admin_email_address
  groot_net_teleport_cluster_domain_name         = var.groot_net_teleport_cluster_domain_name
}
