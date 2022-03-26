FROM python:3.9

COPY ./app /app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 8050
CMD ["python", "app.py"]