import json
import boto3    #AWS SDK for Python

dynamodb = boto3.resource('dynamodb')       #Locally define DynamoDB
table = dynamodb.Table('cloudresume-count')     #Define the table that contains the count


#gets the viewer count from dynamodb and adds 1 
def lambda_handler(event,context):
    response = table.get_item(Key={
        'id' : '1',
    })
    
    views = response['Item']['views']
    views += 1
    print(views)
    
    response = table.put_item(Item={
        'id' : '1',
        'views' : views
    })

    return views