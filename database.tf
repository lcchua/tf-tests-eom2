
resource "aws_db_subnet_group" "lcchua-tf-db-subnet-grp" {
  #name        = "lcchua-tf-eom2-db-subnet-grp"
  name       = "${var.stack_name}-${var.env}-db-subnet-grp-${var.rnd_id}"
  subnet_ids = [for subnet in aws_subnet.lcchua-tf-private-subnet : subnet.id]

  tags = {
    group     = var.stack_name
    form_type = "Terraform Resources"
    Name      = "${var.stack_name}-${var.env}-dsg-${var.rnd_id}"
  }
}

/* Uncomment as needed
data "aws_rds_engine_version" "latest" {
  engine      = var.settings.database.engine
  latest = true
}
*/
resource "aws_db_instance" "lcchua-tf-db" {
  allocated_storage = var.settings.database.allocate_storage
  engine            = var.settings.database.engine
  engine_version    = var.settings.database.engine_version
  #engine_version          = data.aws_rds_engine_version.latest.version
  instance_class = var.settings.database.instance_class
  identifier     = "${var.stack_name}-${var.env}-db-server-${var.rnd_id}"
  #db_name                 = var.settings.database.db_name
  username               = var.settings.database.db_username
  password               = aws_secretsmanager_secret_version.db_secret_ver.secret_string
  db_subnet_group_name   = aws_db_subnet_group.lcchua-tf-db-subnet-grp.id
  vpc_security_group_ids = [aws_security_group.lcchua-tf-db-sg.id]
  skip_final_snapshot    = var.settings.database.skip_final_snapshot

  tags = {
    group     = var.stack_name
    form_type = "Terraform Resources"
    Name      = "${var.stack_name}-${var.env}-db-server-${var.rnd_id}"
  }
}

output "database_endpoint" {
  description = "The endpoint of the database"
  value       = aws_db_instance.lcchua-tf-db.address
}
output "database_port" {
  description = "The port of the database"
  value       = aws_db_instance.lcchua-tf-db.port
}
output "database_version" {
  description = "The version of the database"
  value       = aws_db_instance.lcchua-tf-db.engine_version
}