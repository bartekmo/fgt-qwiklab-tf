variable GCP_PROJECT {
  type    = string
  description = "GCP project id"
}

variable GCE_REGION {
  type = string
  description = "GCE region to use"
}

variable "prefix" {
  type = string
  description = "Prefix to be added to the names of all created resources"
  default = "fgt-"
}

variable "flexvm_token1" {
  type = string
  description = "FlexVM token for primary FortiGate"
}

variable "flexvm_token2" {
  type = string
  description = "FlexVM token for secondary FortiGate"
}

provider "google" {
  project = var.GCP_PROJECT
  region  = var.GCE_REGION
  zone    = "${var.GCE_REGION}-b"
}

provider "google-beta" {
  project = var.GCP_PROJECT
  region  = var.GCE_REGION
  zone    = "${var.GCE_REGION}-b"
}
