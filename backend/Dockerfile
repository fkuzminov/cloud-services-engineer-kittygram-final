FROM python:3.9.7-buster

WORKDIR /code
COPY ./requirements.txt .
RUN pip3 install --upgrade pip && pip3 install -r requirements.txt
COPY . .
EXPOSE 8001
CMD ["gunicorn", "kittygram_backend.wsgi:application", "--bind", "0.0.0.0:8001"]
