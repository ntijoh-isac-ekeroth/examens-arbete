# FastApi

start development server: `uvicorn main:app --reload`\
start production server: `uvicorn main:app`

## Docker

Create image: `docker build -t fastapi .`\
Start image: `docker run -d -p 7777:7777 -p 5000:5000 --name fastapi fastapi`
