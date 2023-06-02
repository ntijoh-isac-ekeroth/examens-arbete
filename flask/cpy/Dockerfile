FROM python:3.9


WORKDIR /code


COPY ./requirements.txt /code/requirements.txt


RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt


COPY ./src /code/app


WORKDIR /code/app


# CMD ["gunicorn", "--worker-class gevent", "-w 12", "-b 0.0.0.0:7778", "patched:app"]

CMD gunicorn --worker-class gevent \
  --workers 12 \
  --bind 0.0.0.0:7778 \
  patched:app