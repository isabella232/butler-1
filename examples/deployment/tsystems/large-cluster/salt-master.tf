resource "null_resource" "salt-master-deploy" {

  depends_on = [
                  "openstack_compute_instance_v2.db-server",
                  "openstack_compute_instance_v2.job-queue",
                  "openstack_compute_instance_v2.salt-master",
                  "openstack_compute_instance_v2.tracker",
                  "openstack_compute_instance_v2.worker"
               ]

  connection {
    user                = "${var.user}"
    private_key         = "${file(var.key_file)}"
    agent               = false
#    bastion_private_key = "${file(var.bastion_key_file)}"
#    bastion_host        = "${var.bastion_host_ip}"
#    bastion_user        = "${var.bastion_user}"
    host                = "${openstack_compute_instance_v2.salt-master.access_ip_v4}"
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
#      "sudo /home/${var.user}/get-worker-ssh-config.sh ${var.bastion_host_ip} ${var.bastion_key_file} ${var.bastion_user} | tee ssh-config-workers",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/systemd/system/consul.service.d/",
      "echo '[Service]' | sudo tee /etc/systemd/system/consul.service.d/override.conf",
      "echo 'LimitNOFILE=1048576' | sudo tee -a /etc/systemd/system/consul.service.d/override.conf",
      "sudo systemctl daemon-reload",
      "sudo service consul restart",
    ]
  }

  provisioner "file" {
    source      = "telegraf.service.patch"
    destination = "/home/${var.user}/telegraf.service.patch"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo patch -p0 /etc/systemd/system/multi-user.target.wants/telegraf.service /home/${var.user}/telegraf.service.patch",
      "sudo systemctl daemon-reload",
    ]
  }

  provisioner "file" {
    source      = "setup-grafana.sh"
    destination = "/home/${var.user}/setup-grafana.sh"
  }
  provisioner "remote-exec" {
#
#   This won't run properly until butler has been deployed
    inline = [
      "chmod +x /home/${var.user}/setup-grafana.sh"
    ]
  }

}
