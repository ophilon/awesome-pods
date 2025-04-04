FROM --platform=$BUILDPLATFORM python:3.13-alpine

WORKDIR /app

COPY requirements.txt app.py /app
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

ENTRYPOINT ["python3"]
CMD ["app.py"]

