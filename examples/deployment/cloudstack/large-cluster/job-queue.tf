resource "cloudstack_instance" "job-queue" {
  depends_on = ["cloudstack_instance.salt-master"]

  zone = "${var.zone}"
  template        = "${var.template}"
  service_offering     = "${var.job_queue_service_offering}"
  security_group_names = ["${cloudstack_security_group.allow-traffic.name}", "${var.main_security_group_name}"]
  name            = "butler-job-queue"
  keypair = "${var.key_pair}"

  connection {
    user                = "${var.user}"
    private_key         = "${file(var.key_file)}"
    bastion_private_key = "${file(var.key_file)}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    agent               = true
  }

  provisioner "file" {
    source      = "salt_setup.sh"
    destination = "/tmp/salt_setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/salt_setup.sh",
      "/tmp/salt_setup.sh ${null_resource.masterip.triggers.address} job-queue \"job-queue, consul-client\"",
    ]
  }
}
