resource "yandex_vpc_security_group" "web_service" {
  name = "web-service-sg"
  description = "Managed by terraform"
    
  network_id  = yandex_vpc_network.internal_network.id
  labels      = {
    firewall = "portal-fw"
  }

  ingress {
    protocol       = "ANY"
    description    = "access to portal vm from internal network"
    v4_cidr_blocks = var.int_ntwrk_cidr
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    protocol       = "TCP"
    description    = "access to portal via HTTPS from external network"
    v4_cidr_blocks = var.ext_ntwrk_cidr
    port           = 443
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
