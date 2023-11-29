output "HOSTNAME" {
  value		= module.vsi.HOSTNAME
}

output "PRIVATE_IP" {
  value		= module.vsi.PRIVATE-IP
}

output "VPC" {
  value		= var.VPC
}

output "ATR_INSTANCE_NAME" {
  description = "Activity Tracker instance name."
  value       = var.ATR_NAME
}

