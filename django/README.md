## Compose sample application
### Django application in dev mode

Project structure:
```
.
├── compose.yaml
├── app
    ├── Dockerfile
    ├── requirements.txt
    └── manage.py

```

[_compose.yaml_](compose.yaml)
```
services: 
  web: 
    build: app 
    ports: 
      - '8000:8000'
```

## Deploy with docker compose

```
$ docker compose up -d
Creating network "django_default" with the default driver
Building web
Step 1/6 : FROM python:3.7-alpine
...
...
Status: Downloaded newer image for python:3.7-alpine
Creating django_web_1 ... done

```

## Expected result

Listing containers must show one container running and the port mapping as below:
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                    NAMES
3adaea94142d        django_web          "python3 manage.py r…"   About a minute ago   Up About a minute   0.0.0.0:8000->8000/tcp   django_web_1
```

After the application starts, navigate to `http://localhost:8000` in your web browser:

Stop and remove the containers
```
$ docker compose down
```

## Build image for Podman

You can build and tag the Django image with `buildah` (or `podman build`) using the same `builder` stage as in `compose.yaml`:

```
$ buildah bud -t django-app:latest --target builder app
```

## Deploy in a pod with Podman

After building the image, you can deploy the Django app with `podman kube play`:

```
$ podman kube play kube.yaml
$ podman ps -ap
```

To stop and remove the pod:

```
$ podman kube down kube.yaml
```
