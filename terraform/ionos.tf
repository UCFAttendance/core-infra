data "ionosdeveloper_dns_zone" "xhoantran" {
  name = "xhoantran.com"
}

resource "ionosdeveloper_dns_record" "cname" {
  zone_id = data.ionosdeveloper_dns_zone.xhoantran.id
  name    = "attendance.${data.ionosdeveloper_dns_zone.xhoantran.name}"
  type    = "CNAME"
  content = aws_lb.app_load_balancer.dns_name
  ttl     = 3600
}
