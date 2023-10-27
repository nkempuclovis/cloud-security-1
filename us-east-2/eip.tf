module "eip" {
  source = "../../terraform-aws-modules/eip"

  instance = module.bastion_host.id

  tags = {
    Name         = "${var.environment}-bastion-eip"
    Environment  = var.environment
    Provisionner = var.provisioner
  }
}