resource "openstack_compute_instance_v2" "worker" {
  depends_on = ["openstack_compute_instance_v2.salt-master"]

  availability_zone = "${var.availability_zone}"
  flavor_name     = "${var.worker_flavor}"
  security_groups = ["${openstack_compute_secgroup_v2.allow-traffic.name}", "${var.main_security_group_name}"]
  name            = "${var.namespace}-worker-${count.index}"
  availability_zone = "${var.availability_zone}"

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
    bastion_private_key = "${file(var.bastion_key_file)}"
    bastion_host        = "${var.bastion_host_ip}"
    bastion_user        = "${var.bastion_user}"
    agent               = false
  }

  count    = "${var.worker_count}"
  key_pair = "${var.key_pair}"

  provisioner "file" {
    source      = "salt_setup.sh"
    destination = "/home/${var.user}/salt_setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/salt_setup.sh",
      "/home/${var.user}/salt_setup.sh ${null_resource.masterip.triggers.address} worker-${count.index} \"worker, consul-client\"",
    ]
  }

  provisioner "file" {
    #
    # This is for T-Systems, where SSH port forwarding is disabled by default
    source      = "sshd-fix.sh"
    destination = "/home/${var.user}/sshd-fix.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.user}/sshd-fix.sh",
      "sudo /home/${var.user}/sshd-fix.sh"
    ]
  }

  provisioner "remote-exec" {
    #
    # This sets up the oneclient mount-point
    inline = [
      "curl -sS -o oneclient.sh http://get.onedata.org/oneclient.sh",
      "chmod +x oneclient.sh",
      "sudo ./oneclient.sh"
    ]
  }
  provisioner "remote-exec" {
    #
    # These options are valid for:
    # Oneclient: 18.02.0-rc5
    # FUSE library: 2.9
    #
    # N.B. They upgraded the default RPM to rc6, but the server is still rc5, so have to manually back off...
    inline = [
      "sudo mkdir -p /data",
      "yum remove -y oneclient",
      "yum install -y http://packages.onedata.org/yum/centos/7x/x86_64/oneclient-18.02.0.rc5-1.el7.centos.x86_64.rpm",
      "sudo oneclient -i -H ebi-otc.onedata.hnsc.otc-service.com -t ${var.oneclient_token} /data --force-direct-io -o allow_other --force-fullblock-read  --rndrd-prefetch-cluster-window=10485760 --rndrd-prefetch-cluster-block-threshold=5 --provider-timeout=7200 -v 1"
    ]
  }

}
