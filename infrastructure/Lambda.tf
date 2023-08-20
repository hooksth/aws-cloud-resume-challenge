#Lambda Function
resource "aws_lambda_function" "API" {
    filename = data.archive_file.zip.output_path
    function_name = "cloudresume-api"
    role = aws_iam_role.iam_for_lambda.arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.11"
    source_code_hash = data.archive_file.zip.output_base64sha256 


}
#IAM Role
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"    
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

#Policy that will allow lambda and dynamodb to talk
resource "aws_iam_policy" "iam_policy_for_lambda_to_DynamoDB" {

  name        = "aws_iam_policy_for_lambda_to_DynamoDB"
  path        = "/"
  description = "give lambda acess to dynamodb"
    policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:*",
          "Effect" : "Allow"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:UpdateItem",
			      "dynamodb:GetItem",
            "dynamodb:PutItem"
          ],
          "Resource" : "arn:aws:dynamodb:*:*:table/cloudresume-count"
        },
      ]
  })
}

#Attaching the policy to the role
resource "aws_iam_policy_attachment" "attach_policy" {
  name = "service-attachment"
  roles = [aws_iam_role.iam_for_lambda.name]
  policy_arn = aws_iam_policy.iam_policy_for_lambda_to_DynamoDB.arn
  
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/Lambda/lambda_function.py"
  output_path = "${path.module}/lambda/function.py.zip"
}

resource "aws_lambda_function_url" "url" {
  function_name = aws_lambda_function.API.function_name
  authorization_type = "NONE"
  
  cors {
    allow_credentials = false
    allow_origins     = ["*"]
  }
}