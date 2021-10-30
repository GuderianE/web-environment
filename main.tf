module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~>2.0"
  subnet_id = "${element(module.vpc.private_subnets, 0)}"
  ami = "${var.ami}"
  name = "webserver"
  instance_type = "${var.ec2_instance_type["${var.environment}"]}"
}