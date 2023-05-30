FROM python:3.9


WORKDIR /code


COPY ./requirements.txt /code/requirements.txt


RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt


COPY ./src /code/app

WORKDIR /code/app

# modify w acording to 2 * cpu cores + 1
# Should not exceed 12 workers
CMD ["gunicorn", "-k uvicorn.workers.UvicornWorker", "-w 12", "-b 0.0.0.0:7777", "main:app"]

#CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "7777"]