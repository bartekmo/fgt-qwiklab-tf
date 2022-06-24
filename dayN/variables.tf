variable "prefix" {
  type = string
  description = "Prefix to be added to all created resources"
}

variable "GOOGLE_PROJECT" {
  type = string
  description = "GCP project id"
  default = "emea-sme-training-2020-275813"
}

variable "GOOGLE_REGION" {
  type = string
  description = "Default GCP region"
  default = "europe-west1"
}
