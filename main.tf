module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~>2.0"
  subnet_ids = "${lookup(local.private_subnets.id)}"
  ami = "${var.ami}"
  name = "webserver"
  instance_type = "${var.ec2_instance_type["${var.environment}"]}"
}