FROM python:3.11-slim

WORKDIR /app

COPY app/requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ ./app/

ENV APP_ENV=container
ENV FLASK_APP=app.main

EXPOSE 5000

CMD ["python", "-m", "app.main"]
