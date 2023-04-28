from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello_world():
    return {"message": "Hello, World! vaea"}

@app.route('/post')
def post(request):
    return handle_post(request)



def handle_post(request):
    return request
