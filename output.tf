output "bastion_elastic_ip" {
  value = data.aws_eip.bastion_ip.public_ip
}

output "bastion_private_key" {
  value     = tls_private_key.generated.private_key_pem
  sensitive = true
}

output "bastion_ssh_connect" {
  value = "ssh -i ~/.ssh/id_rsa ec2-user@${data.aws_eip.bastion_ip.public_ip}"
}

output "bastion_ssh_tunnel" {
  value = "ssh -i ~/.ssh/id_rsa ec2-user@${data.aws_eip.bastion_ip.public_ip} -N -L <localPort>:<remoteAddress>:<remotePort>"
}
