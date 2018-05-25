resource "openstack_compute_instance_v2" "worker" {
  depends_on = ["openstack_compute_instance_v2.salt-master"]

  availability_zone = "${var.availability_zone}"
  flavor_name     = "${var.worker_flavor}"
  security_groups = ["${openstack_compute_secgroup_v2.allow-traffic.name}", "${var.main_security_group_name}"]
  name            = "${var.namespace}-worker-${count.index}"
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
    bastion_private_key = "${file(var.bastion_key_file)}"
    bastion_host        = "${var.bastion_host_ip}"
    bastion_user        = "${var.bastion_user}"
    agent               = true
  }

  count    = "${var.worker_count}"
  key_pair = "${var.key_pair}"

  provisioner "file" {
    source      = "salt_setup.sh"
    destination = "/home/${var.user}/salt_setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/salt_setup.sh",
      "/home/${var.user}/salt_setup.sh ${null_resource.masterip.triggers.address} worker-${count.index} \"worker, consul-client\"",
    ]
  }

#
# This is for T-Systems, where SSH port forwarding is disabled by default
#
  provisioner "file" {
    source      = "sshd-fix.sh"
    destination = "/home/${var.user}/sshd-fix.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/sshd-fix.sh",
      "sudo /home/${var.user}/sshd-fix.sh"
    ]
  }

#
# For the FreeBayes example, unpack the tarball from the git distribution
#
  provisioner "remote-exec" {
    inline = [
      "cd /opt/butler/examples/data/ref",
      "sudo tar xvf human_g1k_v37.20.fasta.tar.gz"
    ]
  }
}
