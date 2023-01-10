import sys
import csv
import boto3

dynamodb = boto3.resource('dynamodb')

tableName = 'ld-devrel-workshop' 
filename = './workshop-students.csv' 

def main():
    csvfile = open(filename)

    write_to_dynamo(csv.DictReader(csvfile))

    return print("Done")

def write_to_dynamo(rows):
    table = dynamodb.Table(tableName)
    with table.batch_writer() as batch:
        for row in rows:
            batch.put_item(
                Item={
                    'id': row['id'],
                    'signin': row['signin'],
                    'client_key': row['client_key'],
                    'server_key': row['server_key']
                }
            )

main()