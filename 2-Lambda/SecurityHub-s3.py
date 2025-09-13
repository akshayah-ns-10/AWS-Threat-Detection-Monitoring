import boto3
import json
import uuid
import datetime

s3 = boto3.client('s3')
S3_BUCKET = "athena-results-aksh"   
OUTPUT_PREFIX = "SecurityHub-Findings/"

def lambda_handler(event, context):
    timestamp = datetime.datetime.utcnow().strftime("%Y%m%d-%H%M%S")
    file_name = f"{OUTPUT_PREFIX}findings-{timestamp}-{uuid.uuid4().hex}.json"
    
    s3.put_object(
        Bucket=S3_BUCKET,
        Key=file_name,
        Body=json.dumps(event, indent=2)
    )
    
    return {
        'status': 'success',
        'file': f"s3://{S3_BUCKET}/{file_name}"
    }
