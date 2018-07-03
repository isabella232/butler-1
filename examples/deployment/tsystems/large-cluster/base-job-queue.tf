resource "openstack_compute_instance_v2" "job-queue" {

  availability_zone = "${var.availability_zone}"
  flavor_name     = "${var.job_queue_flavor}"
  security_groups = ["${openstack_compute_secgroup_v2.allow-traffic.name}", "${var.main_security_group_name}"]
  name            = "${var.namespace}-job-queue"
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
  }

  connection {
    user                = "${var.user}"
    private_key         = "${file(var.key_file)}"
#    bastion_private_key = "${file(var.key_file)}"
#    bastion_host        = "${var.bastion_host_ip}"
#    bastion_user        = "${var.bastion_user}"
    agent               = false
  }

  key_pair = "${var.key_pair}"

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
