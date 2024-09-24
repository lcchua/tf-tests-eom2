resource "aws_db_subnet_group" "lcchua-tf-db-subnet-grp" {
  name        = "lcchua-tf-eom2-db-subnet-grp"
  subnet_ids  = [for subnet in aws_subnet.lcchua-tf-private-subnet : subnet.id]
}

data "aws_db_engine_version" "latest" {
  engine      = var.settings.database.engine
  most_recent = true
}
resource "aws_db_instance" "lcchua-tf-db" {
  allocated_storage = var.settings.database.allocate_storage
  engine = var.settings.database.engine
  #engine_version = var.settings.database.engine_version
  engine_version = data.aws_db_engine_version.latest.version
  instance_class = var.settings.database.instance_class
  #db_name = var.settings.database.db_name
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.lcchua-tf-db-subnet-grp.id
  vpc_security_group_ids = [aws_security_group.lcchua-tf-db-sg.id]
  skip_final_snapshot = var.settings.database.skip_final_snapshot
}
output "database_endpoint" {
  description = "The endpoint of the database"
  value       = aws_db_instance.lcchua-tf-db.address
}
output "database_port" {
  description = "The port of the database"
  value       = aws_db_instance.lcchua-tf-db.port 
}