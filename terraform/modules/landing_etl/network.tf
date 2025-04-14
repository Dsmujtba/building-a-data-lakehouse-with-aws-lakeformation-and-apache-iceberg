data "aws_subnet" "public_a" {
  id = var.public_subnet_a_id
}

data "aws_security_group" "db_sg" {
  id = var.db_sg_id
}
