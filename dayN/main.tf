
module "fgt-ingress" {
  source      = "./fgt-ingress"

  prefix      = var.prefix
  fgt_address =
  fgt_apikey  =
  target_port =
  target_ip   =
}

module "app" {
  source      = "./app-infra"

  prefix      = var.prefix
}
