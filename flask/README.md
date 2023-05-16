# Flask

Start development server: `flask`\
Start production server: `gunicorn -w 8 --port 7778:7778 app:app`

## Docker

Create image: `docker build -t flask .`\
Start image: `docker run -d -p 7778:7778 flask`

## ruff

```bash
ruff . --fix
```
