/* variable "user_name" {
	default="CHANGE_ME"
}
variable "password" {
	default="CHANGE_ME"
}
variable "tenant_name" {
	default="Pan-Prostate"
}
variable "auth_url" {
}
*/

variable "availability_zone" {
        default=""
}

variable "otc_secgroup" {
  default = ""
}

variable "disk_size_gb" { 
        default = 20 
}
variable "main-security-group-id" {}

variable "key_pair" {}

variable "bastion_key_file" {}

variable "bastion_host" {}

variable "bastion_user" {}

variable "image_id" {}

variable "user" {
  default = "centos"
}

variable "key_file" {}

variable "main_network_uuid" {
  default = ""
}

variable "main_network_name" {
  default = ""
}

variable "main_network_id" {
  default = ""
}

variable "floatingip_pool" {
  default = "ext-net"
}

variable "worker_count" {
  default = "1"
}

variable "salt_master_flavor" {
  default = "s1.massive"
}

variable "worker_flavor" {
  default = "s1.massive"
}

variable "db_server_flavor" {
  default = "s1.massive"
}

variable "job_queue_flavor" {
  default = "s1.massive"
}

variable "tracker_flavor" {
  default = "s1.massive"
}

variable "main_security_group_name" {
  default = ""
}
