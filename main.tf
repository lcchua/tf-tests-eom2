
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "lcchua-gen-db-pwd"
}

resource "aws_secretsmanager_secret_version" "db_secret_ver" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = random_password.db_password.result
}

output "secret_arn" {
  description = "The ARN of the secret for reference"
  value = aws_secretsmanager_secret.db_secret.arn
}
