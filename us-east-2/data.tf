data "aws_availability_zones" "available" {}

############# Instance Profile Lookup ##############

data "aws_iam_instance_profile" "base_role" {
  name = "base-ec2-role"
}

################ Ubuntu 20.04 LTS Default Image Lookup ######################

data "aws_ami" "ubuntu_20" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


################ Route53 Data Source Lookup ###############

data "aws_route53_zone" "fojilabs_zone" {
  name = "fojilabs.com."
}

################### Certificate Data Source Lookup ###############

# Find a certificate issued by (not imported into) ACM

data "aws_acm_certificate" "fojilabs_ssl_cert" {
  domain      = "www.dev.fojilabs.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

