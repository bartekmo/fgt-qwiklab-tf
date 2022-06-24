# Auto-discover custom service account
# Use service_account_create.sh to create recommended minimal privileges service
# account. If not found the default Compute Engine account will be used.
data google_service_account fgt {
  account_id      = "fortigatesdn-ro"
}

# Auto-detect your own IP address to add it to the API trusthost list in FortiGate configuration
data "http" "my_ip" {
  url             = "http://api.ipify.org"
}

# Create base deployment of FortiGate HA cluster
module "fortigates" {
  source          = "./fgcp-ha-ap-lb"

  prefix          = "${var.prefix}-"
  region          = var.GCE_REGION
  service_account = data.google_service_account.fgt.email != null ? data.google_service_account.fgt.email : ""
  healthcheck_port = 80
  admin_acl       = ["${data.http.my_ip.body}/32"]
  api_acl         = ["${data.http.my_ip.body}/32"]

  # Use the below subnet names if you create new networks using sample_networks or update to your own
  # Remember to use subnet list as names, not selfLinks
  subnets         = [ for sb in module.sample_networks.subnets : reverse( split("/", sb))[0] ]

  # If creating sample VPC Networks in the same configuration - wait for them to be created!
  # Remove this explicit dependency if using your own pre-existing networks.
  depends_on    = [
    module.sample_networks
  ]
}

## Remove the block below if you're using your own networks
module "sample_networks" {
  source          = "./sample-networks"

  prefix          = var.prefix
  region          = var.GCE_REGION
  networks        = ["external", "internal", "hasync", "mgmt"]
}
