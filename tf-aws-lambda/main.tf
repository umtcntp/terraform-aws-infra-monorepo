provider "aws" {
  region = "eu-central-1"
}

resource "aws_iam_role" "lambda_role" {
  name               = "terraform_aws_lambda_role"
  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
        "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
           "Effect": "Allow",
              "Sid": ""

        }
      ]
    }
    EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "IAM policy for AWS Lambda created by Terraform"
  policy      = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
      ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/python"
  output_path = "${path.module}/python/hello-python.zip"
}

resource "aws_lambda_function" "terraform_lambda_function" {
  filename      = "${path.module}/python/hello-python.zip"
  function_name = "umut-lambda-function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "hello-python.lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

terraform {
  backend "s3" {
    bucket = "umut-terraform-bucket"
    key    = "lambda-function/terraform.tfstate"
    region = "eu-central-1"
  }
}

output "terraform_aws_role_output" {
  value = aws_iam_role.lambda_role.name
}

output "terraform_aws_role_arn_output" {
  value = aws_iam_role.lambda_role.arn
}

output "terraform_logging_arn_output" {
  value = aws_iam_policy.iam_policy_for_lambda.arn
}
