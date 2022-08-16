variable "prefix" {
  type = string
  description = "Prefix to be added to all created resources"
  default = "demo-app"
}

variable "region" {
  type = string
  description = "Default GCP region"
  default = "us-central1"
}

# We'll use shortened region and zone names for some resource names. This is a standard shorting described in
# GCP security foundations.
locals {
  region_short    = replace( replace( replace( replace(var.region, "europe-", "eu"), "australia", "au" ), "northamerica", "na"), "southamerica", "sa")
}