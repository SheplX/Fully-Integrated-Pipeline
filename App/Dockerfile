FROM python:3.9-slim
RUN mkdir /app 
ADD . /app
WORKDIR /app
RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt
EXPOSE 8000
CMD [ "python3", "hello.py" ]