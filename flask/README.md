# Flask

## Setup

Create venv `/path/to/python -m venv ./venv`
Activate venv `source ./venv/bin/activate`
Install requirements `pip install -r ./requirements.txt`

## Flask server

Start development server: `flask`\
Start production server: `gunicorn -w 8 -b 0.0.0.0:7778 app:app`
## Docker

Create image: `docker build -t flask .`\
Start image: `docker run -d -p 7778:7778 --name flask flask`

## ruff

```bash
ruff . --fix
```
