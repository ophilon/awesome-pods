## Podman Kube application

## Deploy

Use podman companion tool `buildah` to build image. 

```
buildah bud -t app:latest
```

You can deploy with Podman

```
$: podman kube play play.yaml
STEP 1/7: FROM python:3.10-alpine
STEP 2/7: WORKDIR /app
...
Successfully tagged localhost/app:latest
```

## Expected result

Listing pods should show the running application

```
$: podman pod ps
POD ID        NAME         STATUS      CREATED         INFRA ID      # OF CONTAINERS
fc1a85eb94bd  flask-redis  Running     38 seconds ago  baaad198c0bb  3
```

## Stop and remove the containers

```
$: podman kube down play.yaml
Pods stopped
Pods removed
```
