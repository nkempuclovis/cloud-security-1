################################################################################
# Route53 ressource
################################################################################

resource "aws_route53_record" "www_prod" {
  zone_id = data.aws_route53_zone.fojilabs_zone.zone_id
  name    = "www.${data.aws_route53_zone.fojilabs_zone.name}"
  type    = "A"
  # ttl     = 300
  # records = [module.alb.lb_arn]
  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}

# resource "aws_route53_record" "prod" {
#   zone_id = data.aws_route53_zone.fojilabs_zone.zone_id
#   name    = "${var.environment}.${data.aws_route53_zone.fojilabs_zone.name}"
#   type    = "A"
#   # ttl     = 300
#   # records = [module.alb.lb_arn]
#   alias {
#     name                   = module.alb.lb_dns_name
#     zone_id                = module.alb.lb_zone_id
#     evaluate_target_health = true
#   }
# }
