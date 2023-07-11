output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.dyallab_webserver.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.dyallab_webserver.public_ip
}

output "instance_name" {
  description = "Name of the EC2 instance"
  value       = aws_instance.dyallab_webserver.tags.Name
}
