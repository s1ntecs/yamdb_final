FROM python:3.7-slim
LABEL owner="sintecs@list.com"

WORKDIR /app

COPY .. /app

RUN python -m pip install --upgrade pip

RUN pip3 install -r requirements.txt --no-cache-dir

WORKDIR /app/api_yamdb

CMD ["gunicorn", "api_yamdb.wsgi:application", "--bind", "0:8000"]