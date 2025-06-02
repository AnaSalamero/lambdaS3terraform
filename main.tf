provider "aws" {
  profile = "my-profile-dehn"
}

# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name 
}

# Upload a file to the S3 bucket
resource "aws_s3_object" "upload_file" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = var.text_file_name
  source = var.text_file_name
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy attachment
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# Lambda S3 Access
resource "aws_iam_role_policy" "lambda_s3_access" {
  name = "lambda_s3_access"
  role = aws_iam_role.lambda_exec_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = "arn:aws:s3:::${var.bucket_name}"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject"
        ],
        Resource = "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })
}

# Lambda function
resource "aws_lambda_function" "my_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.handler"
  runtime       = "python3.9"
  filename      = "lambda_function.zip"
}


