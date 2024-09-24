/* Uncomment as and when needed
# This data object holds all the available availability
# zones in the defined region
data "aws_availablty_zones" "available" {
  state = "available"
}
output "azs-list" {
  description = "stw availability zones in region"
  value       = data.aws_availablty_zones.available.names[*]
}
*/

# Adjust based on your region
locals {
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  #availability_zones = data.aws_availablty_zones.available.names[*]
}
