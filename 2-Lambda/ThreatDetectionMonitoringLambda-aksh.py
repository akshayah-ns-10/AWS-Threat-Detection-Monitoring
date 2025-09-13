import boto3
import time

S3_BUCKET = "athena-results-aksh"                 
QUERY_PREFIX = "Athena-Queries/"                  
OUTPUT_PREFIX = "Athena-Results/"                 
ATHENA_DATABASE = "cloudtrail_logs"              
ATHENA_WORKGROUP = "threat-detection-monitoring"  

s3 = boto3.client('s3')
athena = boto3.client('athena')

def lambda_handler(event, context):
    response = s3.list_objects_v2(Bucket=S3_BUCKET, Prefix=QUERY_PREFIX)
    if 'Contents' not in response:
        return {"status": "No SQL files found"}

    sql_files = [obj['Key'] for obj in response['Contents'] if obj['Key'].endswith('.sql')]

    results_summary = []

    for sql_file in sql_files:
        obj = s3.get_object(Bucket=S3_BUCKET, Key=sql_file)
        query = obj['Body'].read().decode('utf-8')

        exec_response = athena.start_query_execution(
            QueryString=query,
            QueryExecutionContext={'Database': ATHENA_DATABASE},
            ResultConfiguration={'OutputLocation': f"s3://{S3_BUCKET}/{OUTPUT_PREFIX}"},
            WorkGroup=ATHENA_WORKGROUP
        )

        query_execution_id = exec_response['QueryExecutionId']

        while True:
            status = athena.get_query_execution(QueryExecutionId=query_execution_id)['QueryExecution']['Status']['State']
            if status in ['SUCCEEDED', 'FAILED', 'CANCELLED']:
                break
            time.sleep(1)

        results_summary.append({
            'sql_file': sql_file,
            'status': status,
            's3_result': f"s3://{S3_BUCKET}/{OUTPUT_PREFIX}{query_execution_id}.csv"
        })

    return {"results_summary": results_summary}
