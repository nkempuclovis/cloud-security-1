##################################################################
# Application Load Balancer Module
##################################################################

module "alb" {

  source  = "app.terraform.io/fojiglobal/alb/aws"
  version = "1.0.0"

  name               = "${var.environment}-lb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets

  # Attach security groups
  create_security_group = false
  security_groups       = [module.public_sg.security_group_id]

  ################## HTTP to HTTPS Listener Redirection Rule ###############

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
  ]

  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = data.aws_acm_certificate.fojilabs_ssl_cert.arn
    },
  ]

  https_listener_rules = [
    {
      https_listener_index = 0
      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]
      conditions = [{
        host_headers = ["${var.environment}.fojilabs.com", "www.${var.environment}.fojilabs.com"]
      }]
    },
  ]

  target_groups = [
    {
      name                              = "${var.environment}-80-tg"
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      health_check = {
        enabled             = true
        interval            = 10
        path                = "/health.html"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 2
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
     
      tags = {
        Name         = "${var.environment}-80-tg"
        Environment  = var.environment
        Provisionner = var.provisioner
      }
    },
  ]

  lb_tags = {
    Name         = "${var.environment}-lb"
    Environment  = var.environment
    Provisionner = var.provisioner
  }
}