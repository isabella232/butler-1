resource "cloudstack_security_group" "allow-traffic" {
  name        = "butler-firewall"
  description = "Allow traffic across butler instances"
}

resource "cloudstack_security_group_rule" "allow-traffic" {
  security_group_id = "${cloudstack_security_group.allow-traffic.id}"

  rule {
    icmp_type = -1
    icmp_code = -1
    protocol = "icmp"
    cidr_list = ["0.0.0.0/0"]
  }

  rule {
    protocol = "tcp"
    ports = ["22"]
    cidr_list  = ["0.0.0.0/0"]
  }

  rule {
    protocol = "tcp"
    ports = ["1-65535"]
    cidr_list  = ["0.0.0.0/0"]
    user_security_group_list = ["${cloudstack_security_group.allow-traffic.name}"]
  }

  rule {
    protocol = "tcp"
    ports = ["3000"]
    cidr_list = ["0.0.0.0/0"]
  }
}
