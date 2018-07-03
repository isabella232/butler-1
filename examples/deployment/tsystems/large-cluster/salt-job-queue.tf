resource "null_resource" "salt-job-queue-deploy" {

  depends_on = [
                  "openstack_compute_instance_v2.salt-master",
                  "openstack_compute_instance_v2.job-queue",
               ]

  connection {
    user                = "${var.user}"
    private_key         = "${file(var.key_file)}"
#    bastion_private_key = "${file(var.key_file)}"
#    bastion_host        = "${var.bastion_host_ip}"
#    bastion_user        = "${var.bastion_user}"
    agent               = false
    host                = "${openstack_compute_instance_v2.job-queue.access_ip_v4}"
  }

  provisioner "remote-exec" {
    inline = [
      "/home/${var.user}/salt-setup.sh ${null_resource.masterip.triggers.address} job-queue \"job-queue, consul-server\"",
    ]
  }
}
