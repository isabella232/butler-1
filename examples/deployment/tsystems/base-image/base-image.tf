
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
      "sudo patch -p0 /etc/dracut.conf /home/$USER/dracut.conf.patch",
      "sudo dracut -f",
    ]
  }

  provisioner "file" {
    source      = "./master"
    destination = "/home/${var.user}/master"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install epel-release -y",
      "sudo yum -y update",
      "sudo yum install -y python-pip git python-pygit2 wget yum-plugin-priorities",
      "sudo yum install -y gcc gcc-c++ make cmake kernel-devel zlib-devel bzip2-devel xz-devel", # To build freebayes
      "sudo yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm",
#      "sudo yum install -y salt-master salt-minion",
      "sudo yum install -y salt-minion",
      "sudo systemctl disable firewalld",
      "sudo systemctl stop firewalld",
      "yum clean expire-cache",
#      "echo master: salt-master | sudo tee  -a /etc/salt/minion",
#      "echo id: salt-master | sudo tee -a /etc/salt/minion",
#      "echo roles: [salt-master, consul-server, monitoring-server, consul-ui, butler-web, elasticsearch] | sudo tee -a /etc/salt/grains",
#      "sudo hostnamectl set-hostname $2",
      "sudo patch -p0 /etc/salt/minion /home/$USER/minion.patch",
#      "sudo systemctl enable salt-minion",
#      "sudo service salt-minion start",
#
#      "sudo service salt-master stop",
#      "sudo mv /home/${var.user}/master /etc/salt/master",
#      "sudo service salt-master start",
#      "sudo hostname salt-master",
    ]
  }

#  provisioner "file" {
#    source      = "setup-grafana.sh"
#    destination = "/home/${var.user}/setup-grafana.sh"
#  }
#  provisioner "remote-exec" {
#    inline = [
#      "chmod +x /home/${var.user}/setup-grafana.sh"
#    ]
#  }

  provisioner "file" {
    source      = "setup-freebayes.sh"
    destination = "/home/${var.user}/setup-freebayes.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/setup-freebayes.sh",
      "sudo /home/${var.user}/setup-freebayes.sh"
    ]
  }

  provisioner "file" {
    source      = "setup-butler.sh"
    destination = "/home/${var.user}/setup-butler.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/setup-butler.sh",
      "sudo /home/${var.user}/setup-butler.sh"
    ]
  }

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
