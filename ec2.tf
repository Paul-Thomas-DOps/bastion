resource "aws_instance" "bastion-instance" {
  ami                         = var.bastion_config.ec2_instance_ami
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.generated-key.key_name
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  subnet_id                   = data.aws_subnet.playground-public-subnet.id
  iam_instance_profile        = aws_iam_instance_profile.bastion-instance-profile.name
  associate_public_ip_address = true
  user_data                   = data.template_cloudinit_config.bastion-cloudinit.rendered

  tags = merge(local.tags, { Name = "bastion-instance" })
}
