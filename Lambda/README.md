# Lambda

This folder contains AWS Lambda functions used in the project.

- **lambda_function_basic.py** → Test script to validate Athena connectivity.
- **lambda_function_dynamic.py** → Executes Athena queries dynamically via test events and stores results in S3.

Outputs are written to:  
`s3://athena-query-results-aksh/`
