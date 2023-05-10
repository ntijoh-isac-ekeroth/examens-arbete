from time import sleep
from flask import Flask, request

app = Flask(__name__)


@app.route("/raw_json", methods=['GET'])
def raw_json():
    return {"message": "Static GET Success"}

# FIXME: kanske inte använda
@app.route("/html", methods=['GET'])
def html():
    return '<div>Hello World</div'

@app.route('/parse_url/<int:id>', methods=['GET'])
def parse_url(id):
    return {'message': id}

@app.route('/delay/<int:id>', methods=['get'])
def delay(id):
    sleep(id)
    return {"message": id}

@app.route('/post', methods=['POST'])
def post():
    return {"message": "Static POST Success"}

@app.route('/post_read', methods=['POST'])
def post_read():
    return request.get_json()

