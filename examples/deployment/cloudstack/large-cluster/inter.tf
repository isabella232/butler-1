resource "null_resource" "masterip" {
  triggers = {
    address = "${cloudstack_instance.salt-master.ip_address}"
  }
}
