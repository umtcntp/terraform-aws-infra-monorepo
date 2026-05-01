variable "instance_type" {
  description = "instance type ec2 example"
  type        = string
}

variable "instance_count" {
  description = "EC2 instance count"
  type        = number
}

variable "enable_public_id" {
  description = "Enable public IP ID"
  type        = bool
}

variable "user_names" {
  description = "IAM users"
  type        = list(string)
}

variable "project_environment" {
  description = "project name and environment"
  type        = map(string)
}