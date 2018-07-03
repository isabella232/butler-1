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
  }

  connection {
    user                = "${var.user}"
    private_key         = "${file(var.key_file)}"
    agent               = false
#    bastion_private_key = "${file(var.bastion_key_file)}"
#    bastion_host        = "${var.bastion_host_ip}"
#    bastion_user        = "${var.bastion_user}"
  }

  key_pair = "${var.key_pair}"

  provisioner "file" {
    source      = "examples/post-launch-check"
    destination = "/home/${var.user}/post-launch-check"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/post-launch-check/*",
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

#
# This is trying to get the IP of all the workers, to configure the SSH config file.
# There has to be a better way!
  provisioner "file" {
    source      = "get-worker-ssh-config.sh"
    destination = "/home/${var.user}/get-worker-ssh-config.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/get-worker-ssh-config.sh",
    ]
  }

}
