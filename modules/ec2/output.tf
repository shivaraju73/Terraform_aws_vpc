output "instance_id" {
  value = aws_instance.first.id
}
output "public_ip" {
  value = aws_instance.first.public_ip
}
