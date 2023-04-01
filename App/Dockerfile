FROM python:3.9-slim
RUN mkdir /app 
WORKDIR /app
COPY . .
RUN python -m pip install --upgrade pip && \
    pip install -r requirements.txt && \
    rm -rf /root/.cache
EXPOSE 8000
CMD [ "python3", "hello.py" ]