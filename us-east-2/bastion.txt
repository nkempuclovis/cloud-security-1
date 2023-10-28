################################################################################
# E2 Module to Create Bastion Host
################################################################################

module "bastion_host" {
  source = "../../terraform-aws-modules/ec2"

  name = "bastion host"

  ami                    = data.aws_ami.ubuntu_20.id
  instance_type          = var.instance_type
  availability_zone      = element(module.vpc.azs, 0)
  subnet_id              = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [module.bastion_sg.security_group_id]

    associate_public_ip_address = true
  disable_api_stop            = false

  iam_instance_profile = data.aws_iam_instance_profile.base_role.name
  key_name             = var.key_pair_use2

  # only one of these can be enabled at a time
  hibernation = false
  # enclave_options_enabled = true

  user_data = <<-EOT
    #!/bin/bash
    sudo apt update && sudo apt upgrade -y
    sudo reboot
  EOT  

  tags = {
    Name         = "${var.environment}-bastion"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

}