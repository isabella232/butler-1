resource "hfm_virtual_guest" "salt-master" {
  hostname = "butler-salt-master.ibm.com"
  ssh_key_id = "${var.ssh_key_id}"
  os_reference_code =       "${var.os_reference_code}"
  cores = "${var.cores}"
  memory = "${var.memory}"
  env_id = "${var.environment_id}"

  connection {
    user                = "${var.user}"
    private_key         = "${file(var.key_file)}"
    agent               = true
    bastion_private_key = "${file(var.bastion_key_file)}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
  }


  provisioner "file" {
    source      = "./master"
    destination = "/home/centos/master"
  }

  provisioner "file" {
    source      = "salt_setup.sh"
    destination = "/tmp/salt_setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/salt_setup.sh",
      "/tmp/salt_setup.sh `hostname -I` salt-master \"salt-master, consul-server, monitoring-server, consul-ui, butler-web, elasticsearch\"",
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
      "sudo mv /home/centos/master /etc/salt/master",
      "sudo service salt-master start",
      "sudo hostname salt-master",
      #     "sudo semodule -i collectdlocal.pp",
    ]

  }
}
