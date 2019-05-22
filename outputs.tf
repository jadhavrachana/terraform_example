output "elb_dns" {
  value = "${aws_elb.rachanaelb.dns_name}"
}
