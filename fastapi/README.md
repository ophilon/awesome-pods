## Compose sample application
### Python/FastAPI application

Project structure:
```
├── compose.yaml
├── Dockerfile
├── requirements.txt
├── app
    ├── main.py
    ├── __init__.py

```

[_compose.yaml_](compose.yaml)
```
services:
  api:
    build: .
    container_name: fastapi-application
    environment:
      PORT: 8000
    ports:
      - '8000:8000'
    restart: "no"

```

## Deploy with docker compose

```shell
docker-compose up -d --build
```
## Expected result

Listing containers must show one container running and the port mapping as below:
```
$ docker ps
CONTAINER ID   IMAGE          COMMAND       CREATED              STATUS              PORTS                                               NAMES
7087a6e79610   5c1778a60cf8   "/start.sh"   About a minute ago   Up About a minute   80/tcp, 0.0.0.0:8000->8000/tcp, :::8000->8000/tcp   fastapi-application
```

After the application starts, navigate to `http://localhost:8000` in your web browser and you should see the following json response:
```
{
"message": "OK"
}
```

Stop and remove the containers
```
$ docker compose down
```

## Build image for Podman

You can build and tag the FastAPI image with `buildah` (or `podman build`):

```
$ buildah bud -t fastapi-app:latest --target builder .
```

## Deploy in a pod with Podman

After building the image, you can deploy the FastAPI app with `podman kube play`:

```
$ podman kube play kube.yaml
$ podman ps -ap
```

To stop and remove the pod:

```
$ podman kube down kube.yaml
```
