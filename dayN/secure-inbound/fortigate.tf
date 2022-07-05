# Redirect and allow connectivity to the app based on ports and target IP given in the vars
# External IP is created in this module (gcp.tf) so its address can be accessed
# by referencing resource (google_compute_address.inbound.address)

resource "fortios_firewall_vip" "app" {
  name = "${var.prefix}-myapp-${var.port}"
  extintf = "port1"
  extip = google_compute_address.inbound.address
  extport = var.port
  portforward = "enable"
  mappedport = var.target_port
  mappedip {
      range = var.target_ip
  }
}

resource "fortios_firewallservice_custom" "app" {
  name = "myapp_service"
  tcp_portrange = var.port
}

resource "fortios_firewall_policy" "app" {
  name = "${var.prefix}-myapp-allow"
  action = "accept"
  schedule = "always"
  service {
      name = fortios_firewallservice_custom.app.name
  }
  srcintf {
      name = "port1"
  }
  dstintf {
      name = "port2"
  }
  srcaddr {
      name = "all"
  }
  dstaddr {
      name = fortios_firewall_vip.app.name
  }
  nat = "disable"
}

# ELB health check probes need to be redirected to a loopback interface created in day0
# Note: health probes are using the default FGT probe port (8008), which is hard-coded
# in this terraform module. Make sure it matches the value in day0/main.tf

resource "fortios_firewall_vip" "probe" {
  name = "${var.prefix}-myapp-probe-vip"
  extintf = "port1"
  extip = google_compute_address.inbound.address
  extport = 8008
  portforward = "enable"
  mappedport = 8008
  mappedip {
      range = "169.254.255.100"
  }
}

resource "fortios_firewallservice_custom" "probe" {
  name = "myapp_probe_srv"
  tcp_portrange = 8008
}

resource "fortios_firewall_policy" "probe" {
  name = "${var.prefix}-myapp-probe-allow"
    action = "accept"
  schedule = "always"
  service {
      name = fortios_firewallservice_custom.probe.name
  }
  srcintf {
      name = "port1"
  }
  dstintf {
      name = "probe"
  }
  srcaddr {
      name = "all"
  }
  dstaddr {
      name = fortios_firewall_vip.probe.name
  }
  nat = "disable"
}
