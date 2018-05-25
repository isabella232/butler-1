
resource "openstack_compute_instance_v2" "salt-master" {
  availability_zone = "${var.availability_zone}"
  flavor_name     = "${var.salt_master_flavor}"
  security_groups = ["${openstack_compute_secgroup_v2.allow-traffic.name}", "${var.main_security_group_name}"]
  name            = "${var.namespace}-salt-master"

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
    # name = "${var.main_network_name}"
  }

  connection {
    user                = "${var.user}"
    private_key         = "${file(var.key_file)}"
    agent               = false
    bastion_private_key = "${file(var.bastion_key_file)}"
    bastion_host        = "${var.bastion_host_ip}"
    bastion_user        = "${var.bastion_user}"
  }

  key_pair = "${var.key_pair}"

  provisioner "file" {
    source      = "./master"
    destination = "/home/${var.user}/master"
  }

  provisioner "file" {
    source      = "salt_setup.sh"
    destination = "/home/${var.user}/salt_setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/salt_setup.sh",
      "/home/${var.user}/salt_setup.sh `hostname -I` salt-master \"salt-master, consul-server, monitoring-server, consul-ui, butler-web, elasticsearch\"",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install git -y",
      "sudo yum install python-pip -y",
      "sudo yum install salt-master -y",
      "sudo yum install salt-minion -y",
      "sudo yum install python-pygit2 -y",
      "sudo service salt-master stop",
      "sudo mv /home/${var.user}/master /etc/salt/master",
      "sudo service salt-master start",
      "sudo hostname salt-master",
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
      "sudo /home/${var.user}/sshd-fix.sh",
    ]
  }
}
