terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    fortios = {
      source = "fortinetdev/fortios"
    }
  }
}

provider "fortios" {
  hostname = data.terraform_remote_state.day0.outputs.fgt_mgmt_eips[0]
  token    = data.terraform_remote_state.day0.outputs.api_key
  insecure = true
}

provider "google" {
  project  = var.GOOGLE_PROJECT
  region   = var.GOOGLE_REGION
}
