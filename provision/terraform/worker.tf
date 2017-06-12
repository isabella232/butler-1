resource "openstack_compute_instance_v2" "worker" {

        depends_on = ["openstack_compute_instance_v2.salt_master"]

  	image_id = "${var.image_id}"
	flavor_name = "s1.massive"
	security_groups = ["butler-internal"]
	name = "worker-${count.index}"
	network = {
		uuid = "${var.main_network_id}"
	}
	network = {
		uuid = "${var.gnos_network_id}"
	}
	connection {
		user = "${var.user}"
	 	private_key = "${file(var.key_file)}"
	 	bastion_private_key = "${file(var.bastion_key_file)}"
	 	bastion_host = "${var.bastion_host}"
	 	bastion_user = "${var.bastion_user}"
	 	agent = true
	 	
	}

	count = "5"
	key_pair = "${var.key_pair}"
	provisioner "remote-exec" {
		inline = [
		    "sudo yum install epel-release -y",
		    "sudo yum -y update",
		    "sudo yum install yum-plugin-priorities -y",
		    "sudo yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-2016.11-2.el7.noarch.rpm",
		    "sudo yum install salt-minion -y",
		    "sudo service salt-minion stop",
		    "echo 'master: ${null_resource.masterip.triggers.address}' | sudo tee  -a /etc/salt/minion",
		    "echo 'id: worker-${count.index}' | sudo tee -a /etc/salt/minion",
		    "echo 'roles: [worker, germline, consul-client, R]' | sudo tee -a /etc/salt/grains",
		    "sudo hostname worker-${count.index}",
		    "sudo service salt-minion start"
		]
	}
}

