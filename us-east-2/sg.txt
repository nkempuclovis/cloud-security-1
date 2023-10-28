################################################################################
########################## Security Group Module ###############################
################################################################################

#####################################################
# Public Security Group 
#####################################################

module "public_sg" {
  source = "../../terraform-aws-modules/sg"

  name        = var.public_sg_name
  description = "Allows HTTP and HTTPS from Public"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "${var.environment}-${var.public_sg_name}"
    Env         = var.environment
    Provisioner = var.provisioner
  }

  ##### Ingress Rules for Publis Security Group #####
  ###################################################  

  # Default CIDR blocks, which will be used for all ingress rules in this module. Typically these are CIDR blocks of the VPC.
  # If this is not specified then no CIDR blocks will be used.

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]

  ############# HTTP and HTTPS From Public IPV4 ###################

  ingress_with_cidr_blocks = [
    {
      from_port   = var.port_80
      to_port     = var.port_80
      protocol    = var.protocol_tcp
      description = "Allows HTTP from Everywhere IPV4"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = var.port_443
      to_port     = var.port_443
      protocol    = var.protocol_tcp
      description = "Allows HTTPS from Everywhere IPV4"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  ############# HTTP and HTTPS From Public IPV6 ###################

  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = var.port_80
      to_port          = var.port_80
      protocol         = var.protocol_tcp
      description      = "Allows HTTP from Everywhere IPV6"
      ipv6_cidr_blocks = "::/0"
    },
    {
      from_port        = var.port_443
      to_port          = var.port_443
      protocol         = var.protocol_tcp
      description      = "Allows HTTPS from Everywhere IPV6"
      ipv6_cidr_blocks = "::/0"
    },
  ]

  ##### Egress Rules for Publis Security Group #####
  ##################################################

  ############## HTTP and HTTPS to Private Security Group #############

  egress_with_source_security_group_id = [
    {
      from_port                = var.port_80
      to_port                  = var.port_80
      protocol                 = var.protocol_tcp
      description              = "Allows HTTP traffic to Private Subnet"
      source_security_group_id = module.private_sg.security_group_id
    },
    {
      from_port                = var.port_443
      to_port                  = var.port_443
      protocol                 = var.protocol_tcp
      description              = "Allows HTTPS traffic to Private Subnet"
      source_security_group_id = module.private_sg.security_group_id
    },
  ]

}

######################################################
# Private Security Group 
######################################################

module "private_sg" {
  source = "../../terraform-aws-modules/sg"

  name        = var.private_sg_name
  description = "Allow HTTP and HTTPS from Public"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "${var.environment}-${var.private_sg_name}"
    Env         = var.environment
    Provisioner = var.provisioner
  }

  ##### Ingress Rules for Private Security Group #####
  ###################################################

  ############# HTTP and HTTPS From Public Security Group ##############

  ingress_with_source_security_group_id = [
    {
      from_port                = var.port_80
      to_port                  = var.port_80
      protocol                 = var.protocol_tcp
      description              = "Allows HTTP from Public SG"
      source_security_group_id = module.public_sg.security_group_id
    },
    {
      from_port                = var.port_443
      to_port                  = var.port_443
      protocol                 = var.protocol_tcp
      description              = "Allows HTTPS from Public SG"
      source_security_group_id = module.public_sg.security_group_id
    },
    {
      from_port                = var.port_22
      to_port                  = var.port_22
      protocol                 = var.protocol_tcp
      description              = "Allows SSH from Private SG"
      source_security_group_id = module.bastion_sg.security_group_id
    },
  ]

  ##### Egress Rules for Private Security Group #####
  ##################################################

  # Default CIDR blocks, which will be used for all egress rules in this module. Typically these are CIDR blocks of the VPC.
  # If this is not specified then no CIDR blocks will be used.

  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = ["::/0"]

  ############## All to Everywhere IPV4 #############

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allows All traffic to anywhere IPV4"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  ############## All to Everywhere IPV6 #############

  egress_with_ipv6_cidr_blocks = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      description      = "Allows All traffic to anywhere IPV6"
      ipv6_cidr_blocks = "::/0"
    },
  ]

}

######################################################
# Bastion Security Group 
######################################################

module "bastion_sg" {
  source = "../../terraform-aws-modules/sg"

  name        = var.bastion_sg_name
  description = "Allow SSH traffic from Public"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "${var.environment}-${var.bastion_sg_name}"
    Env         = var.environment
    Provisioner = var.provisioner
  }

  ##### Ingress Rules for Private Security Group #####
  ###################################################

  # Default CIDR blocks, which will be used for all egress rules in this module. Typically these are CIDR blocks of the VPC.
  # If this is not specified then no CIDR blocks will be used.

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]

  ############# SSH From Everywhere Security Group IPV4 ##############

  ingress_with_cidr_blocks = [
    {
      from_port   = var.port_22
      to_port     = var.port_22
      protocol    = var.protocol_tcp
      description = "Allows SSH traffic from Everywhere IPV4"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  ############# SSH to Everywhere Security Group IPV4 IPV6 ###################

  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = var.port_22
      to_port          = var.port_22
      protocol         = var.protocol_tcp
      description      = "Allows SSH traffic from Everywhere IPV6"
      ipv6_cidr_blocks = "::/0"
    },
  ]
  ##### Egress Rules for Private Security Group #####
  ##################################################

  # Default CIDR blocks, which will be used for all egress rules in this module. Typically these are CIDR blocks of the VPC.
  # If this is not specified then no CIDR blocks will be used.

  ############## SSH to Private SUbnet #############

  egress_with_source_security_group_id = [
    {
      from_port                = var.port_22
      to_port                  = var.port_22
      protocol                 = var.protocol_tcp
      description              = "Allows SSH traffic to Private Subnet"
      source_security_group_id = module.private_sg.security_group_id
    },
  ]

}
