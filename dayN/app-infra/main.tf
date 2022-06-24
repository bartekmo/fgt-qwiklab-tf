/*resource "google_compute_network" "demo" {
  name                    = "${var.prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "demo" {
  name = "${var.prefix}-sb"
  ip_cidr_range = "10.0.0.0/24"
  network = google_compute_network.demo.self_link
  region = var.region
}

resource "google_compute_firewall" "allow_http" {
  name = "${var.prefix}-allow-http"
  network = google_compute_network.demo.self_link
  allow {
    protocol = "TCP"
    ports = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}
*/

resource "google_compute_instance" "websrv" {
  name = "${var.prefix}-websrv"
  machine_type = "e2-standard-2"
  zone = "${var.region}-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = var.subnet
  }

  metadata_startup_script = file("${path.module}/websrv_startup_script.sh")
}
