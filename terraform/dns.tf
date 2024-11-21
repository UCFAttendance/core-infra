resource "ionoscloud_dns_zone" "ucf_attendance_dns" {
  name = "attendance.xhoantran.com"
  description = "DNS zone for UCF Attendance"
}

resource "ionoscloud_dns_record" "ucf_attendance_dns_record" {
  zone_id = ionoscloud_dns_zone.ucf_attendance_dns.id
  name = "attendance.xhoantran.com"
  type = "CNAME"
  content = aws_lb.app_load_balancer.dns_name
  ttl = 60
}