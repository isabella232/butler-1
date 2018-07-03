resource "null_resource" "salt-worker-deploy" {

  depends_on = [
                  "openstack_compute_instance_v2.salt-master",
                  "openstack_compute_instance_v2.worker",
               ]

  connection {
    user                = "${var.user}"
    private_key         = "${file(var.key_file)}"
#    bastion_private_key = "${file(var.key_file)}"
#    bastion_host        = "${var.bastion_host_ip}"
#    bastion_user        = "${var.bastion_user}"
    agent               = false
    host                = "${element(openstack_compute_instance_v2.worker.*.access_ip_v4, count.index)}"
  }

  count = "${var.worker_count}"

  provisioner "remote-exec" {
    inline = [
      "/home/${var.user}/salt-setup.sh ${null_resource.masterip.triggers.address} worker-${count.index} \"worker, consul-server\"",
    ]
  }
}
