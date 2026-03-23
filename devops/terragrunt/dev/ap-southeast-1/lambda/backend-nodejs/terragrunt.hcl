include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "lambda" {
  path   = find_in_parent_folders("_env/lambda.hcl")
  expose = true
}

inputs = {
  function_name                   = "${include.lambda.locals.stack_name}-backend-nodejs"
  description                     = "Lambda function for backend Node.js application"
  handler                         = "src/lambda.handler"
  runtime                         = "nodejs20.x"
  s3_bucket                       = "${include.lambda.locals.stack_name}-lambda-source-code"
  s3_key                          = "backend-nodejs/backend-nodejs.zip"
  memory_size                     = 512
  timeout                         = 90
  publish                         = true
  create_role                     = false
  lambda_role_arn                 = dependency.lambda-role.outputs.wrapper["backend-nodejs-role"].iam_role_arn
  create_function_url             = true
  function_url_authorization_type = "NONE"
  environment_variables           = {}
  allowed_triggers                = {
                                      apigateway = {
                                        principal  = "apigateway.amazonaws.com"
                                      }
                                    }
  tags                            = include.lambda.locals.tags
}