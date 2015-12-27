resource "aws_route53_zone" "int_livegrep_com" {
  name = "int.livegrep.com"
  vpc_id = "${aws_vpc.livegrep.id}"
}
