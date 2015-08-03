variable "do_token" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_subnet_id" {}
variable "cs_api_url" {}
variable "cs_api_key" {}
variable "cs_secret_key" {}
variable "rs_auth_url" = {}
variable "rs_username" = {}
variable "rs_password" = {}
variable "rs_tenant_name" = {}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "us-east-1"
}

provider "digitalocean" {
  token = "${var.do_token}"
}


provider "cloudstack" {
    api_url = "${var.cs_api_url}"
    api_key = "${var.cs_api_key}"
    secret_key = "${var.cs_secret_key}"
}

resource "aws_instance" "web-aws" {
  ami = "ami-96a818fe"
  instance_type = "t2.micro"
  subnet_id = "${var.aws_subnet_id}"
  associate_public_ip_address = true
  key_name = "terraform-inventory"
  root_block_device = {
    delete_on_termination = true
  }
}

resource "digitalocean_droplet" "web-do" {
  image = "centos-7-0-x64"
  name = "terraform-inventory-1"
  region = "nyc1"
  size = "512mb"
  ssh_keys = [862272]
}

resource "cloudstack_instance" "web-cs" {
    name             = "terraform-inventory-2"
    service_offering = "small"
    template         = "centos-7-0-x64"
    zone             = "nyc2"
}

resource "openstack_compute_instance_v2" "web-rs" {
    name = "terraform-inventory-3"
    region = "ORD"
    image_id = "09de0a66-3156-48b4-90a5-1cf25a905207"
    flavor_id = "2"
    key_pair = "terraform-inventory"
}
