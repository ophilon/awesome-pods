## Podman Kube application

## Deploy

You can deploy with Podman

```
$: podman kube play play.yaml --build
STEP 1/7: FROM python:3.10-alpine
STEP 2/7: WORKDIR /app
...
Successfully tagged localhost/app:latest
```

## Expected result

Listing pods should show the running application

```
$: podman pod ps
POD ID        NAME        STATUS      CREATED        INFRA ID      # OF CONTAINERS
96a26d3b398e  flask       Running    2 minutes ago  1f2e5b472950  2
```

## Stop and remove the containers

```
$: podman kube down play.yaml
Pods stopped
Pods removed
```
