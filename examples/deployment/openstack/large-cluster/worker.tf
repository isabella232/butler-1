resource "openstack_compute_instance_v2" "worker" {
  depends_on = ["openstack_compute_instance_v2.salt-master"]

#  image_id        = "${var.image_id}"
  flavor_name     = "${var.worker_flavor}"
  security_groups = ["${openstack_compute_secgroup_v2.allow-traffic.name}", "${var.main_security_group_name}", "${var.otc_secgroup}"]
  name            = "butler-worker-${count.index}"
  availability_zone = "${var.availability_zone}"

  block_device {
    uuid = "${var.image_id}"
    source_type = "image"
    volume_size = "${var.disk_size_gb}"
    boot_index = 0
    destination_type = "volume"
    delete_on_termination = true
  }

  network = {
    uuid = "${var.main_network_uuid}"
    #name = "${var.main_network_name}"
  }

  connection {
    user                = "${var.user}"
    private_key         = "${file(var.key_file)}"
    bastion_private_key = "${file(var.key_file)}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    agent               = true
  }

  count    = "${var.worker_count}"
  key_pair = "${var.key_pair}"

  provisioner "file" {
    source      = "salt_setup.sh"
    destination = "/tmp/salt_setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/salt_setup.sh",
      "/tmp/salt_setup.sh ${null_resource.masterip.triggers.address} worker-${count.index} \"worker, consul-client\"",
    ]
  }
}
