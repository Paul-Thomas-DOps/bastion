data "template_file" "add-user-keys" {
  template = file("./add_user_public_keys.sh")

  vars = {
    ssh_key = var.ssh_key
  }
}

data "template_file" "associate-elastic-ip-address" {
  template = file("./associate_elastic_ip_address.sh")
  vars = {
    bastion_ip_id = data.aws_eip.bastion_ip.id
    region        = var.region
  }
}

data "template_cloudinit_config" "bastion-cloudinit" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "add-keys.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.add-user-keys.rendered
  }

  part {
    filename     = "associate-keys.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.associate-elastic-ip-address.rendered
  }
}
