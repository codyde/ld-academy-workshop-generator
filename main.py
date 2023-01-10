import json
from flask_cors import CORS
from flask import Flask,jsonify, request, render_template, session
from flask_session import Session 
import ldclient
from ldclient.config import Config
import os
import eventlet
import uuid
import boto3
eventlet.monkey_patch()
from config import ApplicationConfig
from dotenv import load_dotenv, find_dotenv



app = Flask(__name__, static_url_path='',
                  static_folder='build',
                  template_folder='build')
app.config.from_object(ApplicationConfig)

server_session = Session(app)

# LD_KEY = os.environ.get('LD_SERVER_KEY')
load_dotenv()
# LD_KEY = os.environ.get('LD_SERVER_KEY')
# AWS_ACCESS_KEY_ID = os.environ.get('AWS_ACCESS_KEY_ID')
# AWS_SECRET_KEY = os.environ.get('AWS_SECRET_ACCESS_KEY')
AWS_DEFAULT_REGION = 'us-east-2'
S3_BUCKET = 'ld-academy-workshop-s3'
DYNAMO_TABLE = 'ld-academy-workshop'


fallback = '{"dbhost":"db","mode":"local"}'

user = {
    "key": "anonymous"
}

# ldclient.set_config(Config(LD_KEY))


@app.route('/')
def default_path():
    return render_template("index.html")

@app.route('/loader')
def load_data():
    print("Load data from S3 bucket into DynamoDB")

@app.route('/getcreds')
def get_creds():
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(DYNAMO_TABLE)
    # response = table.scan()['Items']
    response = table.scan(
        FilterExpression = 'in_use <> :s',
        ExpressionAttributeValues = {':s' : True,}
    )['Items'] 
    candidate = response[0]
    access = {
        'url': candidate['signin']
        # 'client_key': candidate['client_key'],
        # 'server_key': candidate['server_key']
    }
    print(access)
    candidate['in_use'] = True
    checkin = table.put_item(Item=candidate)
    print(checkin)
    return jsonify(access)

@app.route('/resetworkshop')
def reset_creds():
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(DYNAMO_TABLE)
    # response = table.scan()['Items']
    response = table.scan(
        FilterExpression = 'in_use = :i',
        ExpressionAttributeValues = {':i' : True,}
    )['Items'] 
    for i in response:
        i['in_use'] = False
        table.put_item(Item=i)
        print(i['id']+" Has been checked in")
    candidate = response[0]
    access = {
        'url': candidate['signin']
        # 'client_key': candidate['client_key'],
        # 'server_key': candidate['server_key']
    }
    response = table.scan(
        FilterExpression = 'in_use <> :s',
        ExpressionAttributeValues = {':s' : True,}
    )['Items'] 
    return jsonify(response)



@app.route("/login", methods=["POST"])
def app_login():
    request_data = request.get_json()
    session['key'] = request_data['key']
    status = {
        "status": session['key']+" has been logged in"
    }
    return jsonify(status) 

@app.route("/logout")
def app_logout():
    session.pop('key', default=None)
    status = {
        "status":"logged out"
    }
    return jsonify(status)
   

@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers',
                         'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods',
                         'GET,PUT,POST,DELETE,OPTIONS')
    return response