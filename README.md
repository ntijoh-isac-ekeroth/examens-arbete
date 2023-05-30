# examens-arbete

## Requirements

- Bash Version 4+
- [Vegeta](https://github.com/tsenart/vegeta)
- [jq](https://github.com/stedolan/jq)
- Python 3.9 (See requirements.txt per framework)

## TODO?

- Websockets
- FastApi request models / no models
- Frontend för att visa datan i d3?
- Visa resultat för enskilda steg i cli

## ruff

Ruff is used for python linting

```bash
ruff . --fix
```


# Run testing

## Testing

Basic usage

```bash
./benchmark.sh [flags]
```

```bash
./benchmark.sh -t 30s -u http://localhost:7777 -m only -s '["raw_json"]' 
```


Usage help

```bash
./benchmark.sh -h
Usage: benchmark.sh [flags]
    -h                 Show help menu
    -l                 List all available stages
    -m <mode>          Mode: full, skip, only, low_load (full)
    -r <rate>          Requests per second, 0=inf (0)
    -s <stages>        Stages to include/exclude as JSON array, e.g., '["raw_json", "parse_url", "delay"]' (all)
    -t <duration>      Duration in si units (1s, 5m, 10h)
    -u <url>           Base URL of benchmark (http://localhost:5000)
    -w <max_workers>   Maximum number of workers for vegeta (100)

```

## OS

### MacOs

Due to MacOs shiping with bash 3.2 and this program relying on newer bash features. `./benchmark.sh` points to a newer version of bash installed with brew.\
If running on MacOs do 

```bash
brew install bash
```

### Other

Remove the first line of the code in `./benchmark.sh`.\
The first line should be the path to your bash installation example: `#!/bin/bash`

## Vegeta report
To view the results of the benchmark use `vegeta report`, e.g. 

```bash
vegeta report result.bin
vegeta report -type=json results.bin > metrics.json
vegeta results.bin plot > plot.html
vegeta report -type="hist[0,100ms,200ms,300ms]" results.bin
```

# FastAPI

FastAPI presented with uvicorn under gunicorn

## Setup

Create venv

```bash
/path/to/python -m venv ./venv
```

Activate venv 

```bash
source ./venv/bin/activate
```

Install requirements

```bash
pip install -r ./requirements.txt
```

## FastAPI server

start development server: 

```bash
uvicorn main:app --reload
```

start production server: 

```bash
gunicorn -k uvicorn.workers.UvicornWorker -w 12 -b 0.0.0.0:7777 main:app
```

## Docker

Create image: 

```bash 
docker build -t fastapi .
```

Start image: 

```bash
docker run -d -p 7777:7777 --name fastapi fastapi
```

# Flask

Presented with Gunicorn running gevent workers

## Setup

Create venv

```bash
/path/to/python -m venv ./venv
```

Activate venv 

```bash
source ./venv/bin/activate
```

Install requirements

```bash
pip install -r ./requirements.txt
```

## Flask server

Start development server: 

```bash
flask
```

Start production server: 

```bash
gunicorn -w 8 -b 0.0.0.0:7778 app:app
```

## Docker

Create image: 

```bash
docker build -t flask .
```

Start image: 

```bash
docker run -d -p 7778:7778 --name flask flask
```

# Frontend

## Setup
Install dependencies

```bash
yarn
``` 

Start dev server 

```bash
yarn dev
```
