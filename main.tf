
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "${var.stack_name}-${var.env}-db-secret-${var.rnd_id}"

  tags = {
    group     = var.stack_name
    form_type = "Terraform Resources"
    Name      = "${var.stack_name}-${var.env}-db-secret-${var.rnd_id}"
  }
}

resource "aws_secretsmanager_secret_version" "db_secret_ver" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = random_password.db_password.result
}

output "secret_arn" {
  description = "The ARN of the secret for reference"
  value = aws_secretsmanager_secret.db_secret.arn
}
