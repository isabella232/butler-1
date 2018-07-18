resource "null_resource" "salt-cluster-activate" {
  depends_on = [
                  "null_resource.salt-db-server-deploy",
                  "null_resource.salt-job-queue-deploy",
                  "null_resource.salt-master-deploy",
                  "null_resource.salt-tracker-deploy",
                  "null_resource.salt-worker-deploy",
                  "null_resource.ssh-bastion",
               ]

# Do this for every set of workers I bring up
  triggers {
    something = "${uuid()}"
  }

  connection {
    user = "${var.user}"
    host = "${openstack_compute_instance_v2.salt-master.access_ip_v4}"
    private_key = "${file(var.key_file)}"
#    bastion_private_key = "${file(var.bastion_key_file)}"
#    bastion_host = "${var.bastion_host_ip}"
#    bastion_user = "${var.bastion_user}"
    agent = false
  }

  provisioner "file" {
    source      = "salt-cluster-activate.sh"
    destination = "/home/${var.user}/salt-cluster-activate.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo I am on `hostname`",
      "chmod +x /home/${var.user}/salt-cluster-activate.sh",
#     "sudo /home/${var.user}/salt-cluster-activate.sh"
    ]
  }

}
