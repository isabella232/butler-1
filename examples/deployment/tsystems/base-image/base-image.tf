
resource "openstack_compute_instance_v2" "base" {
  availability_zone = "${var.availability_zone}"
  flavor_name     = "${var.base_image_flavour}"
  security_groups = ["${var.main_security_group_name}"]
  name            = "${var.namespace}-base-image"

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

  provisioner "local-exec" {
    command = <<EOF
(
      echo "Host *"
      echo "  User      ${var.user}"
      echo "  StrictHostKeyChecking   no"
      echo "  IdentityFile ${var.key_file}"
      echo "  UserKnownHostsFile /dev/null"
      echo " "
      echo "Host bastion"
      echo "  HostName ${var.bastion_host_ip}"
 ) | tee base-ssh-config
EOF
  }
  provisioner "file" {
    source      = "base-ssh-config"
    destination = "/home/${var.user}/.ssh/config"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/${var.user}/.ssh/config",
    ]
  }

  provisioner "file" {
    source      = "${var.bastion_key_file}"
    destination = "/home/${var.user}/.ssh/"
  }

#
# This is for T-Systems, where SSH port forwarding is disabled by default
  provisioner "file" {
    source      = "sshd-fix.sh"
    destination = "/home/${var.user}/sshd-fix.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/sshd-fix.sh",
      "sudo /home/${var.user}/sshd-fix.sh",
      "/bin/rm -f /home/${var.user}/sshd-fix.sh",
    ]
  }

  provisioner "file" {
    source      = "minion.patch"
    destination = "/home/${var.user}/minion.patch"
  }

  provisioner "file" {
    source      = "dracut.conf.patch"
    destination = "/home/${var.user}/dracut.conf.patch"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo patch -p0 /etc/dracut.conf /home/${var.user}/dracut.conf.patch",
      "sudo dracut -f",
      "/bin/rm -f /home/${var.user}/dracut.conf.patch"
    ]
  }

  provisioner "file" {
    source      = "./master"
    destination = "/home/${var.user}/master"
  }

  provisioner "file" {
    source      = "setup-base.sh"
    destination = "/home/${var.user}/setup-base.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/setup-base.sh",,
      "sudo /home/${var.user}/setup-base.sh ${var.user}",
      "/bin/rm -f /home/${var.user}/setup-base.sh ${var.user}",
    ]
  }

  provisioner "file" {
    source      = "setup-freebayes.sh"
    destination = "/home/${var.user}/setup-freebayes.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/setup-freebayes.sh",
      "sudo /home/${var.user}/setup-freebayes.sh",
      "/bin/rm -f /home/${var.user}/setup-freebayes.sh",
    ]
  }

  provisioner "file" {
    source      = "setup-butler.sh"
    destination = "/home/${var.user}/setup-butler.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/setup-butler.sh",
      "sudo /home/${var.user}/setup-butler.sh",
      "/bin/rm -f /home/${var.user}/setup-butler.sh",
    ]
  }

  provisioner "file" {
    source      = "install-consul.sh"
    destination = "/home/${var.user}/install-consul.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/install-consul.sh",
      "sudo /home/${var.user}/install-consul.sh",
      "/bin/rm -f /home/${var.user}/install-consul.sh",
    ]
  }
}

resource "null_resource" "epilogue" {

  depends_on = [
   "openstack_compute_instance_v2.base"
  ]

  provisioner "local-exec" {
    command = <<EOF
/bin/rm -f ssh-config
(
  echo "Host *"
  echo "  User      ${var.bastion_user}"
  echo "  StrictHostKeyChecking no"
  echo "  IdentityFile          ${var.bastion_key_file}"
  echo "  UserKnownHostsFile    /dev/null"
  echo "  "
  echo "Host base"
  echo "  HostName ${openstack_compute_instance_v2.base.access_ip_v4}"
  echo " "
) | tee ssh-config
EOF
  }

}
