terraform {
  backend "s3" {
    bucket         = "egp-terraform-state"
    key            = "state/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state"
  }
}

provider "aws" {
  region = var.region
}

locals {
  tags = {
    owner   = "Paul Thomas"
    project = "Bastion Server"
  }
}

data "aws_vpc" "bastion-vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.bastion_config.vpc_name}"]
  }
}

data "aws_subnet" "playground-public-subnet" {
  filter {
    name   = "tag:Name"
    values = [var.bastion_config.public_subnet_name]
  }
}

data "aws_eip" "bastion_ip" {
  filter {
    name   = "tag:name"
    values = ["bastion-ip"]
  }
}

resource "tls_private_key" "generated" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated-key" {
  key_name   = "bastion"
  public_key = tls_private_key.generated.public_key_openssh

  tags = merge(local.tags, { Name = "bastion-key-pair" })
}
