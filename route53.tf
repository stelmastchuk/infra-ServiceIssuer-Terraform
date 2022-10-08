data "aws_route53_zone" "this" {
  name = "digitalbankapi.net"
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "issuer.${data.aws_route53_zone.this.name}"
  type    = "A"


  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
