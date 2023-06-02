from fastapi import FastAPI
from time import sleep
from pydantic import BaseModel


class Post_Read_Body(BaseModel):
    message: str


app = FastAPI()


@app.get("/raw_json")
async def raw_json():
    return {"message": "Static GET Success"}

@app.get('/parse_url/{id}')
async def parse_url(id : int):
    return {'message': id}

@app.get('/delay/{id}')
async def delay(id : int):
    sleep(id)
    return {"message": id}

@app.post('/post')
async def post():
    return {"message": "Static POST Success"}

@app.post('/post_read')
async def post_read(body : Post_Read_Body):
    return body

@app.post('/post_read_big_body')
async def post_read_big_body(body : Post_Read_Body):
    return body
