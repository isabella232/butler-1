output "salt-master" {
  value = "${cloudstack_instance.salt-master.access_ip_v4}"
}

output "db-server" {
  value = "${cloudstack_instance.db-server.access_ip_v4}"
}

output "tracker" {
  value = "${cloudstack_instance.tracker.access_ip_v4}"
}

output "job-queue" {
  value = "${cloudstack_instance.job-queue.access_ip_v4}"
}

output "worker-0" {
  value = "${cloudstack_instance.worker.0.access_ip_v4}"
}

output "worker-1" {
  value = "${cloudstack_instance.worker.1.access_ip_v4}"
}

output "worker-2" {
  value = "${cloudstack_instance.worker.2.access_ip_v4}"
}
