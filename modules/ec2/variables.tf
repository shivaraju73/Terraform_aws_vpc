variable "ami_id" {
  description = "The ID of the AMI to use for the instance"
  type        = string
}
variable "environment" {
  description = "The ID of the AMI to use for the instance"
  type        = string
}
variable "instance_type_dev" {
  description = "The type of instance to create"
  type        = string
}
variable "instance_type_prod" {
  description = "The type of instance to create"
  type        = string
}