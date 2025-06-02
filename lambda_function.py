#!/usr/bin/env python3
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO) #set logging level

def handler(event, context): # lambda entry point
    
    logger.info('Lambda execution started...')
    
    s3 = boto3.client('s3') #define the resource
    bucketname = 'dehn-bucket-test1'
    filename = 'hello-world.txt'

    try:
        resp = s3.get_object(Bucket=bucketname, Key=filename) #access to the bucket
        content = resp['Body'].read().decode('utf-8')
        print(content) # content of the file

        logger.info('Function logic executed successfully.')

        return {
            'statusCode': 200,
            'message': 'File read successfully, see the content in AWS Cloudwatch logs in a few seconds'
        }

    except Exception as e:
        logger.error(f'Error: {str(e)}')

        return {
            'message': 'There was a problem reading the file, see the content in AWS Cloudwatch logs in a few seconds'
        }
    
    finally:
        logger.info('Lambda execution completed.')

