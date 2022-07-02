//The application itself
module "app" {
  source       = "./app-infra"

  prefix       = "${var.prefix}-myapp"
  subnet       = data.terraform_remote_state.day0.outputs.internal_subnet
  region       = data.terraform_remote_state.day0.outputs.region
}

//Forward traffic to the app
module "secure_inbound" {
  source       = "./secure-inbound"

  prefix       = "${var.prefix}-myapp"
  protocol     = "TCP"
  port         = 80
  target_ip    = module.app.app_ip
  target_port  = 80

  region       = data.terraform_remote_state.day0.outputs.region
}

//Output the IP address of application
output "application_ip" {
  value = module.secure_inbound.application_ip
}
