variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "memories-app"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "prod"
}

variable "domain_name" {
  type        = string
  description = "Root domain name"
  default     = "clovermoments.store"
}

variable "frontend_domain_name" {
  type        = string
  description = "Frontend domain name"
  default     = "www.clovermoments.store"
}

variable "api_domain_name" {
  type        = string
  description = "API domain name"
  default     = "api.clovermoments.store"
}

variable "budget_limit_usd" {
  type        = number
  description = "Monthly AWS budget limit in USD"
  default     = 5
}

variable "budget_alert_email" {
  type        = string
  description = "Email address for AWS budget alerts"
  default     = "umutcantop1998@gmail.com"
}

variable "frontend_bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name for frontend static files"
  default     = "clovermoments-store-frontend"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t4g.small"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH into EC2"
  default     = "31.223.96.155/32"
}

variable "enable_frontend_custom_domain" {
  type        = bool
  description = "Enable custom domain for CloudFront after ACM certificate is issued"
  default     = true
}