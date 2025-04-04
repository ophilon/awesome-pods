## Podman Kube application

## Build

You can build and tag image with `buildah`

```
$ buildah bud -t app2:latest
STEP 1/7: FROM python:3.13-alpine
STEP 2/7: STOPSIGNAL "SIGINT"
STEP 3/7: WORKDIR /app
STEP 4/7: COPY app.py requirements.txt /app
STEP 5/7: RUN --mount=type=cache,target=/root/.cache/pip pip3 install -r requirements.txt
...
```

## Deploy in a pod

You can deploy with `podman kube play`

```
$ podman kube play kube.yaml
```

## Expected result

Listing containers should show running application in a pod

```
$ podman ps -ap
CONTAINER ID  IMAGE                           COMMAND       CREATED        STATUS                   PORTS                   NAMES               POD ID        PODNAME
a5d50f62c4c9  localhost/podman-pause:4.9.3-0                7 seconds ago  Up 8 seconds             0.0.0.0:8000->8000/tcp  530387649ebf-infra  530387649ebf  flask2
7a12de68f812  localhost/app2:latest           app.py        7 seconds ago  Up 8 seconds (starting)  0.0.0.0:8000->8000/tcp  flask2-app2         530387649ebf  flask2
8951d2ca06b4  docker.io/library/redis:alpine  redis-server  7 seconds ago  Up 8 seconds             0.0.0.0:8000->8000/tcp  flask2-redis        530387649ebf  flask2

$ curl localhost:8000
This webpage has been viewed 1 time(s)
```

## Stop and remove the pod

```
$ podman kube down kube.yaml
Pods stopped:
4f36a9f651b8ee5d11c543a6b3befe9c7bbc99c9aa25b7c04246314a24d32e22
Pods removed:
4f36a9f651b8ee5d11c543a6b3befe9c7bbc99c9aa25b7c04246314a24d32e22
Secrets removed:
Volumes removed:
```
