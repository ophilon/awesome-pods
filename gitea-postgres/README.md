## Gitea with PostgreSQL
This example defines one of the base setups for Gitea. More details on how to customize the installation and the compose file can be found in [Gitea documentation](https://docs.gitea.io/en-us/install-with-docker/).


Project structure:
```
.
├── compose.yaml
├── gitea.kube
├── gitea-kube.yaml
├── pod.yaml
└── README.md
```

[_pod.yaml_](pod.yaml)
```
name: gitea
services:
  gitea:
    image: gitea/gitea:latest
    environment:
      - DB_TYPE=postgres
      - DB_HOST=db:5432
      - DB_NAME=gitea
      - DB_USER=gitea
      - DB_PASSWD=gitea
    volumes:
      - git_data:/data
    ports:
      - 3000:3000
  db:
    image: postgres:alpine
    environment:
      - POSTGRES_USER=gitea
      - POSTGRES_PASSWORD=gitea
      - POSTGRES_DB=gitea
    volumes:
      - db_data:/var/lib/postgresql/data
volumes:
  db_data:
  git_data:
```

Let's try [podlet tool](https://github.com/containers/podlet) to automate migration process from `docker compose` to `podman kube play` config. First, install `podlet` according to the [installation instructions](https://github.com/containers/podlet/blob/main/docs/installation.md).
Then convert the pod.yaml to `podman kube play` manifest:

```
$ podlet -f. compose --kube pod.yaml
Wrote to file: ./gitea.kube
Wrote to file: ./gitea-kube.yaml
```

check generated file:

```
$ podman kube play gitea-kube.yaml
$ podman ps -ap
CONTAINER ID  IMAGE                                    COMMAND               CREATED         STATUS         PORTS                             NAMES               POD ID        PODNAME
03ab6362206b  localhost/podman-pause:5.4.0-1739232000                        56 seconds ago  Up 57 seconds  0.0.0.0:3000->3000/tcp            9e01104d3505-infra  9e01104d3505  gitea
62c44db05dca  docker.io/gitea/gitea:latest             /usr/bin/s6-svsca...  56 seconds ago  Up 57 seconds  0.0.0.0:3000->3000/tcp, 22/tcp    gitea-gitea         9e01104d3505  gitea
a999254d0928  docker.io/library/postgres:alpine        postgres              56 seconds ago  Up 57 seconds  0.0.0.0:3000->3000/tcp, 5432/tcp  gitea-db            9e01104d3505  gitea
```

When deploying this setup, podman maps the gitea container port 3000 to
the same port of the host as specified in the compose file.

Navigate to `http://localhost:3000` in your web browser to access the installed
Gitea service.

![page](output.jpg)

Stop and remove the containers

```
$ podman pod stop gitea
$ podman pod rm gitea
```

To remove all Gitea data, delete the named volumes:
```
$ podman volume ls
DRIVER      VOLUME NAME
local       git_data
local       db_data
$ podman volume rm db_data git_data
```
