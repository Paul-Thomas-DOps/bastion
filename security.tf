resource "aws_security_group" "bastion-sg" {
  name   = "bastion-access-security-group"
  vpc_id = data.aws_vpc.bastion-vpc.id

  dynamic "ingress" {
    for_each = var.bastion_config.ingress_blocks
    content {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = [ingress.value["cidr"]]
      description = "SSH - ${ingress.value["name"]}"
    }
  }

  dynamic "ingress" {
    for_each = var.bastion_config.ingress_blocks
    content {
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_blocks = [ingress.value["cidr"]]
      description = "HTTP - ${ingress.value["name"]}"
    }
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    self        = true
    description = "onward HTTP from this group"
  }

  dynamic "ingress" {
    for_each = var.bastion_config.ingress_blocks
    content {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = [ingress.value["cidr"]]
      description = "HTTPS - ${ingress.value["name"]}"
    }
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    self        = true
    description = "onward HTTPS from this group"
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = var.bastion_config.egress_blocks
  }

  tags = merge(local.tags, { Name = "bastion-access-security-group" })
}
