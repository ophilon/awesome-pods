## Sample application with `docker compose` config and `podman kube play` manifest

### TRAEFIK proxy with GO backend

For both deploys created `make` files: `make_compose` and `make_pods` accordingly, standard Makefile is the link to proper file. To explore both container tools, check your distribution and install docker, podman, buildah, make, go compiler, envsubst.

Project structure:
```
.
├── Containerfile
├── Dockerfile -> Containerfile
├── Makefile -> make_pods
├── README.md
├── compose.yaml
├── kube.yaml
├── main.go
├── make_compose
└── make_pods
```

### docker compose setup

[_compose.yaml_](compose.yaml)
```
services:
  frontend:
    image: traefik:latest
    container_name: traefik
    command: --providers.docker --entrypoints.web.address=:8080 --providers.docker.exposedbydefault=false
    ports:
      # The HTTP port
      - "8080:8080"
    volumes:
      # So that Traefik can listen to the Docker events
      - /var/run/docker.sock:/var/run/docker.sock
    depends_on:
      - backend
  backend:
    build: .
    image: backend
    container_name: backend
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.go.rule=Path(`/`)"
      - "traefik.http.services.go.loadbalancer.server.port=8080"
```

The compose file defines an application with two services `frontend` and `backend`.
When deploying the application, docker compose maps port 8080 of the frontend service container to the same port of the host as specified in the file. Make sure port 8080 on the host is not already being in use.

Make the link to Makefile: `ln -s make_compose Makefile`. Now you can just run `make` to see available targets and either check resulting commands with `make -n target` or run it without -n option.

### podman setup

[_kube.yaml_](kube.yaml)

```
apiVersion: v1
kind: Pod
metadata:
  name: go-app
spec:
  containers:
  - image: docker.io/library/traefik:latest
    name: traefik
    ports:
    - containerPort: 8080
      hostPort: 8080
    volumeMounts:
    - mountPath: $XDG_RUNTIME_DIR/podman/podman.sock
      name: traefik-podman.sock
  - image: localhost/backend:latest
    name: backend
  volumes:
  - hostPath:
      path: $XDG_RUNTIME_DIR/podman/podman.sock
    name: traefik-podman.sock
```

Podman and it's companion buildah give you much more interesting practice. First of all, podman implements part of kubernetes API, see the [podman api specification](https://docs.podman.io/en/latest/_static/api.html?version=v5.4) for complete list, i.e. it can help you get familiar with some of k8s api resources. The buildah tool also gives new approach for building containers, see the [buildah tutorial](https://developers.redhat.com/blog/2021/01/11/getting-started-with-buildah).

Redirect Makefile to make_pods: `ln -s make_pods Makefile` and use `make` to explore it. Below are some comments.

```
$ nl make_pods 
     1	.PHONY: help up clean down logs test ps stats shell
     2	help:
     3	        @echo -e "make_pods avalable targets:\n"
     4	        @make -pRrq 2>/dev/null|grep -v ^Makefile|grep -P '^\w+:'|sort
     5	back: main.go make_pods
     6	        -buildah rm backend
     7	        buildah from --name backend scratch
     8	        CGO_ENABLED='0' go build -v -ldflags "-w -s" -o back main.go
     9	        buildah copy backend back /usr/local/bin/backend
    10	        buildah config --entrypoint '["/usr/local/bin/backend"]' backend
    11	        buildah commit backend backend:latest
    12	clean:
    13	        podman system prune -f
    14	down:
    15	        envsubst < kube.yaml | podman kube down -
    16	up: down
    17	        envsubst < kube.yaml | podman kube play -
    18	logs:
    19	        podman pod logs go-app
    20	test:
    21	        curl localhost:8080
    22	ps:
    23	        podman ps -ap
    24	stats:
    25	        podman stats --no-stream
    26	shell:
    27	        podman exec -ti go-app-traefik /bin/sh```
```

Line 5 defines the dependencies: target **back** will build the binary only if main.go code or make_pods itself newer than resulting binary.

Line 6 deletes the container backend, with tiny `-` prefix to ignore error if no container named backend exists.

Lines 7-10 create container named backend from scratch - buildah commands follow the usual Dockerfile commands, but in lower case: FROM -> from, COPY -> copy, RUN -> run, ENTRYPOINT -> `config --entrypoint`, etc. You see here big difference from traditional `docker buildx` approach - you work in 2 contexts at the same time, in local context using installed `go` compiler, and container context, copy files to/from container, run commands inside container, etc. Other new possibility with `buildah` - you can build image step by step, i.e. debug build process.

Line 8 compiles `main.go` code into `back` binary with proper flags

Line 11 commits resulting container to new image with tag `backend:latest`

The target `up`, line 16, depends on target `down`, line 14, i.e. it first stops pod and deletes containers, if still running.

The target `down` in line 15 substitutes global variable $XDG_RUNTIME_DIR from the user `env` and run `podman kube` commands with fixed kube.yaml from STDIN. The same for target `up`, see line 17: this is the specific of podman - it works completely in userspace, containers communicate via user's own podman.sock, `envsubst` makes pipeline UID aware. 


