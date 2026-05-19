output "budget_name" {
  value = aws_budgets_budget.monthly_cost_budget.name
}

output "backend_instance_id" {
  value = aws_instance.backend.id
}

output "backend_public_ip" {
  value = aws_eip.backend_eip.public_ip
}

output "backend_api_temporary_url" {
  value = "http://${aws_eip.backend_eip.public_ip}:5050"
}

output "api_domain_name" {
  value = var.api_domain_name
}

output "api_dns_record" {
  value = {
    type  = "A"
    name  = "api"
    value = aws_eip.backend_eip.public_ip
  }
}

output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend.bucket
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.frontend.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "frontend_temporary_url" {
  value = "https://${aws_cloudfront_distribution.frontend.domain_name}"
}

output "frontend_domain_name" {
  value = var.frontend_domain_name
}

output "frontend_dns_record" {
  value = {
    type  = "CNAME"
    name  = "www"
    value = aws_cloudfront_distribution.frontend.domain_name
  }
}

output "frontend_acm_dns_validation_records" {
  value = [
    for dvo in aws_acm_certificate.frontend.domain_validation_options : {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  ]
}