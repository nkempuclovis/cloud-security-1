################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../terraform-aws-modules/vpc"

  name = "${var.environment}-vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  #### VPC Tags
  vpc_tags = {
    Name         = "${var.environment}-vpc"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

  #### Public Subnets Tags
  public_subnet_tags = {
    Name         = "${var.environment}-public-subnet"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

  ### Public Route Table Tags
  public_route_table_tags = {
    Name         = "${var.environment}-public-rt"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

  ### Private Subnets Tags
  private_subnet_tags = {
    Name         = "${var.environment}-private-subnet"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

  ### Private Route Table Tags
  private_route_table_tags = {
    Name         = "${var.environment}-private-rt"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

  ### Internet Gateway Tags
  igw_tags = {
    Name         = "${var.environment}-igw"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

  ### Nat Gateway tags
  nat_gateway_tags = {
    Name         = "${var.environment}-ngw"
    Environment  = var.environment
    Provisionner = var.provisioner
  }

  ### EIP Tags
  nat_eip_tags = {
    Name         = "${var.environment}-eip"
    Environment  = var.environment
    Provisionner = var.provisioner
  }
}