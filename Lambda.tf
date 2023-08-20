resource "aws_lambda_function" "API" {
    filename = data.archive_file.zip_the_python_code.output_path
    function_name = "cloudresume-api"
    role = aws_iam_role.iam_for_lambda.arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.11"
    source_code_hash = data.archive_file.zip_the_python_code.output_base64sha256 


}

resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"    
    assume_role_policy = 
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/Lambda/"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function_url" "url" {
  function_name = aws_lambda_function.API.function_name
  authorization_type = "NONE"
  
}