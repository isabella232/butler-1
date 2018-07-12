resource "null_resource" "salt-tracker-deploy" {

  depends_on = [
                  "openstack_compute_instance_v2.salt-master",
                  "openstack_compute_instance_v2.tracker",
               ]

  connection {
    user                = "${var.user}"
    private_key         = "${file(var.key_file)}"
#    bastion_private_key = "${file(var.key_file)}"
#    bastion_host        = "${var.bastion_host_ip}"
#    bastion_user        = "${var.bastion_user}"
    agent               = false
    host                = "${openstack_compute_instance_v2.tracker.access_ip_v4}"
  }

  provisioner "remote-exec" {
    inline = [
      "/home/${var.user}/salt-setup.sh ${null_resource.masterip.triggers.address} tracker \"tracker, consul-server\"",
    ]
  }

  provisioner "file" {
    source      = "airflow.cfg.patch"
    destination = "/home/${var.user}/airflow.cfg.patch"
  }
  provisioner "file" {
    source      = "airflow-scheduler.service.patch"
    destination = "/home/${var.user}/airflow-scheduler.service.patch"
  }
  provisioner "file" {
    source      = "setup-tracker.sh"
    destination = "/home/${var.user}/setup-tracker.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo /home/${var.user}/setup-tracker.sh"
    ]
  }

  provisioner "file" {
    source      = "setup-large-scale-test.sh"
    destination = "/home/${var.user}/setup-large-scale-test.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/setup-large-scale-test.sh",
      "/home/${var.user}/setup-large-scale-test.sh"
    ]
  }
}
