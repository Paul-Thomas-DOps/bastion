Creates a bastion server for connecting to a VPC via ssh

Requires config (.tfvars) in the format:
```
bastion_config = {
  ingress_blocks = [
    {
      name = "<name>",
      cidr = "<cidr>"
    }
  ]

  egress_blocks = [
    "0.0.0.0/0"
  ]

  ec2_instance_ami   = "<ami id>"
  public_subnet_name = "<name>"
  vpc_name           = "<name>"
}

region  = "<region>"
ssh_key = "ssh-rsa <key> <user>"
```