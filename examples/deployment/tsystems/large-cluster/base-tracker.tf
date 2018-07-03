resource "openstack_compute_instance_v2" "tracker" {

  flavor_name     = "${var.tracker_flavor}"
  name            = "${var.namespace}-tracker"
  availability_zone = "${var.availability_zone}"
  security_groups = ["${openstack_compute_secgroup_v2.allow-traffic.name}", "${var.main_security_group_name}"]
  availability_zone = "${var.availability_zone}"

  network = {
    uuid = "${var.main_network_uuid}"
  }

  block_device {
    uuid = "${var.image_id}"
    source_type = "image"
    volume_size = "${var.disk_size_gb}"
    boot_index = 0
    destination_type = "volume"
    delete_on_termination = true
  }

  connection {
    user                = "${var.user}"
    private_key         = "${file(var.key_file)}"
#    bastion_private_key = "${file(var.key_file)}"
#    bastion_host        = "${var.bastion_host_ip}"
#    bastion_user        = "${var.bastion_user}"
    agent               = false
  }

  provisioner "file" {
    source      = "run-freebayes.sh"
    destination = "/home/${var.user}/run-freebayes.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/run-freebayes.sh",
    ]
  }

  provisioner "file" {
    source      = "salt-setup.sh"
    destination = "/home/${var.user}/salt-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/salt-setup.sh",
    ]
  }
}
