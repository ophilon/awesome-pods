USER:
the main goal of this project and 41 subprojects in folders - to migrate compose.yaml configs to podman kuby.yaml manifests. Please, use best proctices and most effective podman API options for new app setup, and create  manifests podman kube play command

AGENT:


**File Glob Results:**

- **/home/ophil/src/awesome-pods/angular/compose.yaml**
- **/home/ophil/src/awesome-pods/angular/kube.yaml**
- **/home/ophil/src/awesome-pods/apache-php/compose.yaml**
- **/home/ophil/src/awesome-pods/apache-php/kube.yaml**
- **/home/ophil/src/awesome-pods/aspnet-mssql/compose.yaml**
- **/home/ophil/src/awesome-pods/django-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/django/compose.yaml**
- **/home/ophil/src/awesome-pods/django/kube.yaml**
- **/home/ophil/src/awesome-pods/elasticsearch-logstash-kibana/compose.yaml**
- **/home/ophil/src/awesome-pods/fastapi/compose.yaml**
- **/home/ophil/src/awesome-pods/fastapi/kube.yaml**
- **/home/ophil/src/awesome-pods/flask-redis/compose.yaml**
- **/home/ophil/src/awesome-pods/flask-redis/kube.yaml**
- **/home/ophil/src/awesome-pods/flask/compose.yaml**
- **/home/ophil/src/awesome-pods/flask/kube.yaml**
- **/home/ophil/src/awesome-pods/gitea-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/gitea-postgres/kube.yaml**
- **/home/ophil/src/awesome-pods/minecraft/compose.yaml**
- **/home/ophil/src/awesome-pods/minecraft/kube.yaml**
- **/home/ophil/src/awesome-pods/nextcloud-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/nextcloud-redis-mariadb/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-aspnet-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-flask-mongo/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-flask-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-golang-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-golang-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-golang/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-nodejs-redis/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-wsgi-flask/compose.yaml**
- **/home/ophil/src/awesome-pods/pihole-cloudflared-DoH/compose.yaml**
- **/home/ophil/src/awesome-pods/plex/compose.yaml**
- **/home/ophil/src/awesome-pods/plex/kube.yaml**
- **/home/ophil/src/awesome-pods/portainer/compose.yaml**
- **/home/ophil/src/awesome-pods/portainer/kube.yaml**
- **/home/ophil/src/awesome-pods/postgresql-pgadmin/compose.yaml**
- **/home/ophil/src/awesome-pods/prometheus-grafana/compose.yaml**
- **/home/ophil/src/awesome-pods/rails-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/react-express-mongodb/compose.yaml**
- **/home/ophil/src/awesome-pods/react-express-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/react-java-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/react-nginx/compose.yaml**
- **/home/ophil/src/awesome-pods/react-rust-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/sparkjava-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/sparkjava/compose.yaml**
- **/home/ophil/src/awesome-pods/sparkjava/kube.yaml**
- **/home/ophil/src/awesome-pods/spring-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/traefik-golang/compose.yaml**
- **/home/ophil/src/awesome-pods/traefik-golang/kube.yaml**
- **/home/ophil/src/awesome-pods/vuejs/compose.yaml**
- **/home/ophil/src/awesome-pods/vuejs/kube.yaml**
- **/home/ophil/src/awesome-pods/wasmedge-kafka-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/wasmedge-mysql-nginx/compose.yaml**
- **/home/ophil/src/awesome-pods/wireguard/compose.yaml**
- **/home/ophil/src/awesome-pods/wireguard/kube.yaml**
- **/home/ophil/src/awesome-pods/wordpress-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/wordpress-mysql/kube.yaml**




**Files Read:**

**/home/ophil/src/awesome-pods/django/kube.yaml**
```
apiVersion: v1
kind: Pod
metadata:
  name: django
spec:
  containers:
    - name: web
      image: django-app
      ports:
        - containerPort: 8000
          hostPort: 8000
      livenessProbe:
        httpGet:
          path: /
          port: 8000
        initialDelaySeconds: 5
        periodSeconds: 30
```

**/home/ophil/src/awesome-pods/django/compose.yaml**
```
services:
  web: 
    build:
      context: app
      target: builder
    ports: 
      - '8000:8000'

```

**/home/ophil/src/awesome-pods/CONTRIBUTING.md**
```
# Contributing

Contributions should be made via pull requests. Pull requests will be reviewed by one or more maintainers and merged when acceptable.

The goal of the **Awesome pods** is to provide a curated list of application samples that can be easily deployed with [podman kube play](https://docs.podman.io/en/latest/markdown/podman-kube.1.html).

## Three ways migrate from compose.yaml to kube.yaml

This project started as fork of [awesome-compose](https://github.com/docker/awesome-compose). Authors did a great job, original code saved in the **compose** branch - you can check it out any time. However, all compose.yaml configs kept and sometimes will work correctly with `podman-compose` command. The status of [podman-compose project](https://github.com/containers/podman-compose) well explained by [Matthew Heon](https://www.redhat.com/en/blog/podman-compose-docker-compose). The power of podman it's compatibility with some k8s API's, which allows smooth migration to kubernetes. So, let's start accustom yourself to brave new world of kuber.

### 1. Create pod and add containers via podman commands, see folder `wordpress-mysql`

1. for convenience, move app specific variables from compose.yaml into .env files, for example:

```
$ cat .env.db
MYSQL_ROOT_PASSWORD=secret
MYSQL_DATABASE=mydb
MYSQL_USER=myuser
MYSQL_PASSWORD=mypassword
```

2. create pod

```
$ podman pod create --name wpod -p 8080:80
```

3. add containers

```
$ podman run -d --pod wpod --env-file .env.db --name=db docker.io/library/mariadb:latest
$ podman run -d --pod wpod --env-file .env.wp --name=web docker.io/library/wordpress:latest
```

4. check pod status

```
$ podman ps -ap
CONTAINER ID  IMAGE                               COMMAND               CREATED         STATUS         PORTS                 NAMES               POD ID        PODNAME
843b257ea988  localhost/podman-pause:4.9.3-0                            45 minutes ago  Up 45 minutes  0.0.0.0:8080->80/tcp  ae8541531313-infra  ae8541531313  wpod
fc3578afbc60  docker.io/library/mariadb:latest    mariadbd              45 minutes ago  Up 45 minutes  0.0.0.0:8080->80/tcp  wpod-db             ae8541531313  wpod
c5419ad8f275  docker.io/library/wordpress:latest  apache2-foregroun...  45 minutes ago  Up 45 minutes  0.0.0.0:8080->80/tcp  wpod-web            ae8541531313  wpod
```

5. generate kube.yaml file

```
$ podman generate kube wpod|tee kube.yaml
```

6. generation kube manifest possible both on running and stopped pod. However, to check new config you should delete running pod, and possibly, to prevent creds changes, delete persistent volumes

```
$ podman pod rm wpod
$ podman volume ls
$ podman volume rm data web
```

7. kube play new kube.yaml

```
$ podman kube play kube.yaml
```

### 2. Create new kube.yaml from below template. May need some additional commands to build containers from code, see proper README.md.

```
$ cat kube.template.yaml
# Save the output of this file and use kubectl create -f to import
# it into Kubernetes.
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: appname
  name: podname
spec:
  containers:
  - args:
    - mariadbd
    env:
    - name: VAR1
      value: val1
    image: docker.io/library/mariadb:latest
    name: db
    ports:
    - containerPort: 80
      hostPort: 8080
    volumeMounts:
    - mountPath: /var/lib/mysql
      name: data-pvc
  - args:
    - apache2-foreground
    env:
    - name: VAR2
      value: value2
    image: docker.io/library/wordpress:latest
    name: web
    volumeMounts:
    - mountPath: /var/www/html
      name: web-pvc
  restartPolicy: Always
  volumes:
  - name: data-pvc
    persistentVolumeClaim:
      claimName: data
  - name: web-pvc
    persistentVolumeClaim:
      claimName: web
```

### 3. Use [podlet tool](https://github.com/containers/podlet) to automate migration process from `docker compose` to `podman kube play` config

1. copy original compose.yaml into new pod.yaml - we have to delete some incompatible options, podlet v.0.3.0 still needs some manual tweaks, see examples below.

```
$ podlet compose --kube pod.yaml
Error: 
   0: error converting compose file
   1: error converting compose file into Kubernetes YAML
   2: `name` is required
```

2. add `name: gitea` as first line in pod.yaml, see more in [gitea-postgres/README.md](gitea-postgres/README.md), and repeat above command for next incompatible options. Here are some:

```
Error:
... Kubernetes pods do not support per container `restart` options
... `expose` is not supported for Kubernetes pod containers
```

3. after fixing error messages run command with `-f .` option to generate 2 files:

```$ podlet -f. compose --kube pod.yaml 
Wrote to file: ./gitea.kube
Wrote to file: ./gitea-kube.yaml
```

4. check generated file:

```
$ podman kube play gitea-kube.yaml
$ podman ps -ap
CONTAINER ID  IMAGE                                    COMMAND               CREATED         STATUS         PORTS                             NAMES               POD ID        PODNAME
03ab6362206b  localhost/podman-pause:5.4.0-1739232000                        56 seconds ago  Up 57 seconds  0.0.0.0:3000->3000/tcp            9e01104d3505-infra  9e01104d3505  gitea
62c44db05dca  docker.io/gitea/gitea:latest             /usr/bin/s6-svsca...  56 seconds ago  Up 57 seconds  0.0.0.0:3000->3000/tcp, 22/tcp    gitea-gitea         9e01104d3505  gitea
a999254d0928  docker.io/library/postgres:alpine        postgres              56 seconds ago  Up 57 seconds  0.0.0.0:3000->3000/tcp, 5432/tcp  gitea-db            9e01104d3505  gitea

```

## Missing an example?

You can request a new example of an application by submitting an issue to our GitHub repository.

Before submitting a new application, check if there isn't already application sample matching your need.

If there is one, consider updating it instead of creating a new one.

If you would like to submit a new application example, please start by submitting a proposal as an issue. The maintainers will then use this issue to discuss what the most valuable example for the application, technology, language, or framework would be.

After the choice has been made, you can submit a pull request with the example remembering to:
- include an example README.md to describe the application and explain how to run/use the sample.
- edit the global README.md to add your sample in the repository main list.

## Commit Messages

Commit messages should follow best practices and explain the context of the
problem and how it was solved-- including any caveats or follow up changes
required. They should tell the story of the change and provide readers an
understanding of what led to it.

[How to Write a Git Commit Message](http://chris.beams.io/posts/git-commit/)
provides a good guide for how to do so.

In practice, the best approach to maintaining a nice commit message is to
leverage a `git add -p` and `git commit --amend` to formulate a solid
change set. This allows one to piece together a change, as information becomes
available.

If you squash a series of commits, don't just submit that. Re-write the commit
message, as if the series of commits was a single stroke of brilliance.

That said, there is no requirement to have a single commit for a pull request,
as long as each commit tells the story. For example, if there is a feature that
requires a package, it might make sense to have the package in a separate commit
then have a subsequent commit that uses it.

Remember, you're telling part of the story with the commit message. Don't make
your chapter weird.

## Sign your work

The sign-off is a simple line at the end of the explanation for the patch. Your
signature certifies that you wrote the patch or otherwise have the right to pass
it on as an open-source patch. The rules are pretty simple: if you can certify
the below (from [developercertificate.org](http://developercertificate.org/)):

```
Developer Certificate of Origin
Version 1.1

Copyright (C) 2004, 2006 The Linux Foundation and its contributors.
660 York Street, Suite 102,
San Francisco, CA 94110 USA

Everyone is permitted to copy and distribute verbatim copies of this
license document, but changing it is not allowed.

Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.
```

Then you just add a line to every git commit message:

    Signed-off-by: Joe Smith <joe.smith@email.com>

Use your real name (sorry, no pseudonyms or anonymous contributions.)

If you set your `user.name` and `user.email` git configs, you can sign your
commit automatically with `git commit -s`.

```





**Files Read:**

**/home/ophil/src/awesome-pods/aspnet-mssql/compose.yaml**
```
services:
  web:
    build: app/aspnetapp
    ports:
      - 80:80
  db:
    environment:
      ACCEPT_EULA: "Y"
      SA_PASSWORD: example_123
    # mssql server image isn't available for arm64 architecture, so we use azure-sql instead
    image: mcr.microsoft.com/azure-sql-edge:1.0.4
    # If you really want to use MS SQL Server, uncomment the following line
    #image: mcr.microsoft.com/mssql/server
    restart: always
    healthcheck:
        test: ["CMD-SHELL", "/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P example_123 -Q 'SELECT 1' || exit 1"]
        interval: 10s
        retries: 10
        start_period: 10s
        timeout: 3s     
         
       

```





**Files Read:**

**/home/ophil/src/awesome-pods/fastapi/compose.yaml**
```
services:
  api:
    build:
      context: .
      target: builder
    container_name: fastapi-application
    environment:
      PORT: 8000
    ports:
      - '8000:8000'
    restart: "no"

```

**/home/ophil/src/awesome-pods/fastapi/kube.yaml**
```
apiVersion: v1
kind: Pod
metadata:
  name: fastapi
spec:
  containers:
    - name: api
      image: fastapi-app
      env:
        - name: PORT
          value: "8000"
      ports:
        - containerPort: 8000
          hostPort: 8000
      livenessProbe:
        httpGet:
          path: /
          port: 8000
        initialDelaySeconds: 5
        periodSeconds: 30
```

**/home/ophil/src/awesome-pods/sparkjava/compose.yaml**
```
services:
  sparkjava:
    build: sparkjava
    ports:
      - 8080:8080

```

**/home/ophil/src/awesome-pods/sparkjava/kube.yaml**
```
apiVersion: v1
kind: Pod
metadata:
  name: sparkjava
spec:
  containers:
    - name: sparkjava
      image: sparkjava-app
      ports:
        - containerPort: 8080
          hostPort: 8080
      livenessProbe:
        httpGet:
          path: /
          port: 8080
        initialDelaySeconds: 5
        periodSeconds: 30
```





**Files Read:**

**/home/ophil/src/awesome-pods/wordpress-mysql/kube.yaml**
```
# Save the output of this file and use kubectl create -f to import
# it into Kubernetes.
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: wordpress
  name: wpod
spec:
  containers:
  - args:
    - mariadbd
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: somewordpress
    - name: MYSQL_USER
      value: wordpress
    - name: MYSQL_PASSWORD
      value: wordpress
    - name: MYSQL_DATABASE
      value: wordpress
    image: docker.io/library/mariadb:latest
    name: db
    ports:
    - containerPort: 80
      hostPort: 8080
    volumeMounts:
    - mountPath: /var/lib/mysql
      name: data-pvc
  - args:
    - apache2-foreground
    env:
    - name: WORDPRESS_DB_NAME
      value: wordpress
    - name: WORDPRESS_DB_USER
      value: wordpress
    - name: WORDPRESS_DB_HOST
      value: 127.0.0.1
    - name: WORDPRESS_DB_PASSWORD
      value: wordpress
    image: docker.io/library/wordpress:latest
    name: web
    volumeMounts:
    - mountPath: /var/www/html
      name: wp-pvc
  restartPolicy: Always
  volumes:
  - name: data-pvc
    persistentVolumeClaim:
      claimName: data
  - name: wp-pvc
    persistentVolumeClaim:
      claimName: web


```

**/home/ophil/src/awesome-pods/gitea-postgres/kube.yaml**
```
apiVersion: v1
kind: Pod
metadata:
  name: gitea-pg
spec:
  containers:
    - name: postgres
      image: postgres
      env:
        - name: POSTGRES_DB
          value: gitea
        - name: POSTGRES_USER
          value: gitea
        - name: POSTGRES_PASSWORD
          value: gitea
      ports:
        - containerPort: 5432
          hostPort: 5432
      volumeMounts:
        - name: postgres-data
          mountPath: /var/lib/postgresql/data
      resources: {}
    
    - name: gitea
      image: gitea/gitea:latest
      env:
        - name: DB_TYPE
          value: postgres
        - name: DB_HOST
          value: localhost:5432
        - name: DB_NAME
          value: gitea
        - name: DB_USER
          value: gitea
        - name: DB_PASSWD
          value: gitea
      ports:
        - containerPort: 3000
          hostPort: 3000
        - containerPort: 2222
          hostPort: 2222
      volumeMounts:
        - name: gitea-data
          mountPath: /data
      resources: {}

  volumes:
    - name: postgres-data
      emptyDir: {}
    - name: gitea-data
      emptyDir: {}

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/aspnet-mssql/kube.yaml
+++ /home/ophil/src/awesome-pods/aspnet-mssql/kube.yaml
@@ -0,0 +1,35 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: aspnet-mssql
+  labels:
+    app: aspnet-mssql
+spec:
+  restartPolicy: Always
+  containers:
+    - name: web
+      image: aspnet-app
+      ports:
+        - containerPort: 80
+          hostPort: 80
+      livenessProbe:
+        httpGet:
+          path: /
+          port: 80
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: db
+      image: mcr.microsoft.com/azure-sql-edge:1.0.4
+      env:
+        - name: ACCEPT_EULA
+          value: "Y"
+        - name: SA_PASSWORD
+          value: "example_123"
+      livenessProbe:
+        exec:
+          command:
+            - /bin/sh
+            - -c
+            - /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P example_123 -Q 'SELECT 1'
+        initialDelaySeconds: 20
+        periodSeconds: 30

```




**Command Executed:**
```bash
cd /home/ophil/src/awesome-pods/aspnet-mssql && ls
```

**Output:**
```
app  compose.yaml  kube.yaml  make_compose  output.jpg	README.md
```



**Files Read:**

**/home/ophil/src/awesome-pods/aspnet-mssql/README.md**
```
## Compose sample application: ASP.NET with MS SQL server database

Project structure:
```
.
├── app
│   ├── aspnetapp
│   │   ├── appsettings.Development.json
|   |   └── ...
│   ├── ...
│   └── Dockerfile
└── compose.yaml
```

[_compose.yaml_](compose.yaml)
```
services:
  web:
    build: app
    ports:
    - 80:80
  db:
    # mssql server image isn't available for arm64 architecture, so we use azure-sql instead
    image: mcr.microsoft.com/azure-sql-edge:1.0.4
    # If you really want to use MS SQL Server, uncomment the following line
    #image: mcr.microsoft.com/mssql/server
    ...
```
The compose file defines an application with two services `web` and `db`. The image for the web service is built with the Dockerfile inside the `app` directory (build parameter).

When deploying the application, docker compose maps the container port 80 to port 80 of the host as specified in the file.
Make sure port 80 on the host is not being used by another container, otherwise the port should be changed.

> ℹ️ **_INFO_**  
> For compatibility purpose between `AMD64` and `ARM64` architecture, we use Azure SQL Edge as database instead of MS SQL Server.  
> You still can use the MS SQL Server image by uncommenting the following line in the Compose file   
> `#image: mcr.microsoft.com/mssql/server`

## Deploy with docker compose

```
$ docker compose up -d
Creating network "aspnet-mssql_default" with the default driver
Building web
Step 1/13 : FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
2.1: Pulling from dotnet/core/sdk
....
....
a9dca2f6722a: Pull complete
Digest: sha256:9b700672670bb3db4b212e8aef841ca79eb2fce7d5975a5ce35b7129a9b90ec0
Status: Downloaded newer image for microsoft/mssql-server-linux:latest
Creating aspnet-mssql_web_1 ... done
Creating aspnet-mssql_db_1  ... done
```


## Expected result

Listing containers must show two containers running and the port mapping as below:
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
7f3a2a7ea5c0        microsoft/mssql-server-linux   "/opt/mssql/bin/sqls…"   4 minutes ago       Up 4 minutes        1433/tcp             aspnet-mssql_db_1
27342dde8b64        aspnet-mssql_web               "dotnet aspnetapp.dll"   4 minutes ago       Up 4 minutes        0.0.0.0:80->80/tcp   aspnet-mssql_web_1
```

After the application starts, navigate to `http://localhost:80` in your web browser.

![page](output.jpg)

Stop and remove the containers

```
$ docker compose down
```

```



I’ve started applying your migration goal and created a `kube.yaml` for one of the missing samples using the existing patterns and podman‑friendly options.

## Example: `aspnet-mssql` manifest

New file: `aspnet-mssql/kube.yaml`

```yaml path="/home/ophil/src/awesome-pods/aspnet-mssql/kube.yaml" start=1 end=35
apiVersion: v1
kind: Pod
metadata:
  name: aspnet-mssql
  labels:
    app: aspnet-mssql
spec:
  restartPolicy: Always
  containers:
    - name: web
      image: aspnet-app
      ports:
        - containerPort: 80
          hostPort: 80
      livenessProbe:
        httpGet:
          path: /
          port: 80
        initialDelaySeconds: 10
        periodSeconds: 30
    - name: db
      image: mcr.microsoft.com/azure-sql-edge:1.0.4
      env:
        - name: ACCEPT_EULA
          value: "Y"
        - name: SA_PASSWORD
          value: "example_123"
      livenessProbe:
        exec:
          command:
            - /bin/sh
            - -c
            - /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P example_123 -Q 'SELECT 1'
        initialDelaySeconds: 20
        periodSeconds: 30
```
Key points / best practices applied:

- Single Pod with both `web` and `db` containers, mirroring `compose.yaml`.
- Explicit `restartPolicy: Always` (matches Compose’s `restart: always` for the DB and is the typical choice for app pods).
- `hostPort`/`containerPort` mapping `80:80` to keep behavior identical to Compose.
- HTTP `livenessProbe` on the web container (`/` on port 80), matching the style used in `flask`, `fastapi`, `sparkjava`, etc.
- `exec`-based `livenessProbe` on the DB, derived from the Compose `healthcheck` (same `sqlcmd` check, with reasonable delay/period).

No volumes are defined here, so the DB storage is ephemeral (similar to the original Compose, which doesn’t model persistence). If you want to showcase persistence, we can extend this with an `emptyDir` or PVC pattern like in `gitea-postgres` / `wordpress-mysql`.

## Podman commands for this sample

Build the app image (Compose’s `build: app/aspnetapp`):

```bash
cd aspnet-mssql
podman build -t aspnet-app app/aspnetapp
```
Run the pod with `podman kube play`:

```bash
cd aspnet-mssql
podman kube play kube.yaml
```
Check that the containers and pod are up:

```bash
podman ps -ap
```
Tear everything down when you’re done:

```bash
cd aspnet-mssql
podman kube down kube.yaml
```
---

If this structure matches what you want, I can proceed through the remaining directories that lack `kube.yaml` (e.g. `elasticsearch-logstash-kibana`, `nextcloud-*`, `nginx-*`, `react-*`, etc.), applying the same best‑practice patterns and adding appropriate `podman kube play` commands for each. Tell me which sample you’d like me to tackle next or if you prefer we go in a specific order.

USER:
yes, please proceed

AGENT:


**File Glob Results:**

- **/home/ophil/src/awesome-pods/aspnet-mssql/kube.yaml**
- **/home/ophil/src/awesome-pods/angular/compose.yaml**
- **/home/ophil/src/awesome-pods/angular/kube.yaml**
- **/home/ophil/src/awesome-pods/apache-php/compose.yaml**
- **/home/ophil/src/awesome-pods/apache-php/kube.yaml**
- **/home/ophil/src/awesome-pods/aspnet-mssql/compose.yaml**
- **/home/ophil/src/awesome-pods/django-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/django/compose.yaml**
- **/home/ophil/src/awesome-pods/django/kube.yaml**
- **/home/ophil/src/awesome-pods/elasticsearch-logstash-kibana/compose.yaml**
- **/home/ophil/src/awesome-pods/fastapi/compose.yaml**
- **/home/ophil/src/awesome-pods/fastapi/kube.yaml**
- **/home/ophil/src/awesome-pods/flask-redis/compose.yaml**
- **/home/ophil/src/awesome-pods/flask-redis/kube.yaml**
- **/home/ophil/src/awesome-pods/flask/compose.yaml**
- **/home/ophil/src/awesome-pods/flask/kube.yaml**
- **/home/ophil/src/awesome-pods/gitea-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/gitea-postgres/kube.yaml**
- **/home/ophil/src/awesome-pods/minecraft/compose.yaml**
- **/home/ophil/src/awesome-pods/minecraft/kube.yaml**
- **/home/ophil/src/awesome-pods/nextcloud-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/nextcloud-redis-mariadb/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-aspnet-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-flask-mongo/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-flask-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-golang-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-golang-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-golang/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-nodejs-redis/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-wsgi-flask/compose.yaml**
- **/home/ophil/src/awesome-pods/pihole-cloudflared-DoH/compose.yaml**
- **/home/ophil/src/awesome-pods/plex/compose.yaml**
- **/home/ophil/src/awesome-pods/plex/kube.yaml**
- **/home/ophil/src/awesome-pods/portainer/compose.yaml**
- **/home/ophil/src/awesome-pods/portainer/kube.yaml**
- **/home/ophil/src/awesome-pods/postgresql-pgadmin/compose.yaml**
- **/home/ophil/src/awesome-pods/prometheus-grafana/compose.yaml**
- **/home/ophil/src/awesome-pods/rails-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/react-express-mongodb/compose.yaml**
- **/home/ophil/src/awesome-pods/react-express-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/react-java-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/react-nginx/compose.yaml**
- **/home/ophil/src/awesome-pods/react-rust-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/sparkjava-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/sparkjava/compose.yaml**
- **/home/ophil/src/awesome-pods/sparkjava/kube.yaml**
- **/home/ophil/src/awesome-pods/spring-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/traefik-golang/compose.yaml**
- **/home/ophil/src/awesome-pods/traefik-golang/kube.yaml**
- **/home/ophil/src/awesome-pods/vuejs/compose.yaml**
- **/home/ophil/src/awesome-pods/vuejs/kube.yaml**
- **/home/ophil/src/awesome-pods/wasmedge-kafka-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/wasmedge-mysql-nginx/compose.yaml**
- **/home/ophil/src/awesome-pods/wireguard/compose.yaml**
- **/home/ophil/src/awesome-pods/wireguard/kube.yaml**
- **/home/ophil/src/awesome-pods/wordpress-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/wordpress-mysql/kube.yaml**




**Files Read:**

**/home/ophil/src/awesome-pods/django-postgres/compose.yaml**
```
services:
  db:
    image: postgres
    volumes:
      - ./data/db:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
  web:
    build: .
    command: python manage.py runserver 0.0.0.0:8000
    volumes:
      - .:/code
    ports:
      - "8000:8000"
    environment:
      - POSTGRES_NAME=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    depends_on:
      - db

```

**/home/ophil/src/awesome-pods/rails-postgres/compose.yaml**
```
services:
  db:
    image: postgres
    volumes:
      - ./tmp/db:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: password
  web:
    build: .
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - .:/myapp
    ports:
      - "3000:3000"
    depends_on:
      - db

```

**/home/ophil/src/awesome-pods/spring-postgres/compose.yaml**
```
services:
  backend:
    build: backend
    ports:
      - 8080:8080
    environment:
      - POSTGRES_DB=example
    networks:
      - spring-postgres
  db:
    image: postgres
    restart: always
    secrets:
      - db-password
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - spring-postgres
    environment:
      - POSTGRES_DB=example
      - POSTGRES_PASSWORD_FILE=/run/secrets/db-password
    expose:
      - 5432
volumes:
  db-data:
secrets:
  db-password:
    file: db/password.txt
networks:
  spring-postgres:

```

**/home/ophil/src/awesome-pods/sparkjava-mysql/compose.yaml**
```
services:
  backend:
    build: backend
    ports:
      - 8080:8080
    secrets:
      - db-password
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10.6.4-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8.0.27
    restart: always
    secrets:
      - db-password
    volumes:
      - db-data:/var/lib/mysql
    environment:
      - MYSQL_DATABASE=example
      - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db-password
    expose:
      - 3306
      - 33060   
volumes:
  db-data:
secrets:
  db-password:
    file: db/password.txt

```

**/home/ophil/src/awesome-pods/react-express-mongodb/compose.yaml**
```
services:
  frontend:
    build:
      context: frontend
      target: development
    ports:
      - 3000:3000
    stdin_open: true
    volumes:
      - ./frontend:/usr/src/app
      - /usr/src/app/node_modules
    restart: always
    networks:
      - react-express
    depends_on:
      - backend

  backend:
    restart: always
    build:
      context: backend
      target: development
    volumes:
      - ./backend:/usr/src/app
      - /usr/src/app/node_modules
    depends_on:
      - mongo
    networks:
      - express-mongo
      - react-express
    expose: 
      - 3000
  mongo:
    restart: always
    image: mongo:4.2.0
    volumes:
      - mongo_data:/data/db
    networks:
      - express-mongo
    expose:
      - 27017
networks:
  react-express:
  express-mongo:

volumes:
  mongo_data:

```

**/home/ophil/src/awesome-pods/react-express-mysql/compose.yaml**
```
services:
  backend:
    build:
      args:
      - NODE_ENV=development
      context: backend
      target: development
    command: npm run start-watch
    environment:
      - DATABASE_DB=example
      - DATABASE_USER=root
      - DATABASE_PASSWORD=/run/secrets/db-password
      - DATABASE_HOST=db
      - NODE_ENV=development
    ports:
      - 80:80
      - 9229:9229
      - 9230:9230
    secrets:
      - db-password
    volumes:
      - ./backend/src:/code/src:ro
      - ./backend/package.json:/code/package.json
      - ./backend/package-lock.json:/code/package-lock.json
      - back-notused:/opt/app/node_modules
    networks:
      - public
      - private
    depends_on:
      - db
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10.6.4-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8.0.27
    command: '--default-authentication-plugin=mysql_native_password'
    restart: always
    secrets:
      - db-password
    volumes:
      - db-data:/var/lib/mysql
    networks:
      - private
    environment:
      - MYSQL_DATABASE=example
      - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db-password
  frontend:
    build:
      context: frontend
      target: development
    ports:
      - 3000:3000
    volumes:
      - ./frontend/src:/code/src
      - /code/node_modules
    networks:
      - public
    depends_on:
      - backend
networks:
  public:
  private:
volumes:
  back-notused:
  db-data:
secrets:
  db-password:
    file: db/password.txt

```

**/home/ophil/src/awesome-pods/react-java-mysql/compose.yaml**
```
services:
  backend:
    build: backend
    restart: always
    secrets:
      - db-password
    environment:
      MYSQL_HOST: db
    networks:
      - react-spring
      - spring-mysql
    depends_on:
      db:
        condition: service_healthy
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10.6.4-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8.0.19
    environment:
      - MYSQL_DATABASE=example
      - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db-password
    restart: always
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "--silent"]
      interval: 3s
      retries: 5
      start_period: 30s
    secrets:
      - db-password
    volumes:
      - db-data:/var/lib/mysql
    networks:
      - spring-mysql
  frontend:
    build:
      context: frontend
      target: development
    ports:
      - 3000:3000
    volumes:
      - ./frontend/src:/code/src
      - /project/node_modules
    networks:
      - react-spring
    depends_on:
      - backend
    expose:
      - 3306
      - 33060
volumes:
  db-data: {}
secrets:
  db-password:
    file: db/password.txt
networks:
  react-spring: {}
  spring-mysql: {}

```

**/home/ophil/src/awesome-pods/react-nginx/compose.yaml**
```
services:
  frontend:
    build:
      context: .
    container_name: frontend
    ports:
      - "80:80"

```

**/home/ophil/src/awesome-pods/react-rust-postgres/compose.yaml**
```
name: react-rust-postgres
services:
  frontend:
    build:
      context: frontend
      target: development
    networks:
      - client-side
    ports:
      - 3000:3000
    volumes:
      - ./frontend/src:/code/src:ro

  backend:
    build:
      context: backend
      target: development
    environment:
      - ADDRESS=0.0.0.0:8000
      - RUST_LOG=debug
      - PG_DBNAME=postgres
      - PG_HOST=db
      - PG_USER=postgres
      - PG_PASSWORD=mysecretpassword
    networks:
      - client-side
      - server-side
    volumes:
      - ./backend/src:/code/src
      - backend-cache:/code/target
    depends_on:
      - db

  db:
    image: postgres:12-alpine
    restart: always
    environment:
      - POSTGRES_PASSWORD=mysecretpassword
    networks:
      - server-side
    ports:
      - 5432:5432
    volumes:
      - db-data:/var/lib/postgresql/data

networks:
  client-side: {}
  server-side: {}

volumes:
  backend-cache: {}
  db-data: {}

```





**Files Read:**

**/home/ophil/src/awesome-pods/flask-redis/kube.yaml**
```
apiVersion: v1
kind: Pod
metadata:
  name: flask2
spec:
  containers:
    # flask container
    - image: app2
      name: app2
      ports:
        - containerPort: 8000
          hostPort: 8000
      livenessProbe:
        httpGet:
          path: /
          port: 8000
        initialDelaySeconds: 5 # default is 0
        periodSeconds: 30 # default is 10
    # redis container
    - image:  docker.io/redis:alpine
      name: redis

```

**/home/ophil/src/awesome-pods/traefik-golang/kube.yaml**
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
      name: podman.sock
  - image: localhost/backend:latest
    name: backend
  volumes:
  - hostPath:
      path: $XDG_RUNTIME_DIR/podman/podman.sock
    name: podman.sock

```





**File Glob Results:**




**Command Executed:**
```bash
cd /home/ophil/src/awesome-pods/django-postgres && ls
```

**Output:**
```
compose.yaml  Containerfile  images  make_compose  README.md
```



**Files Read:**

**/home/ophil/src/awesome-pods/django-postgres/README.md**
```
# Quickstart: Compose and Django

This quick-start guide demonstrates how to use Docker Compose to set up and run a simple Django/PostgreSQL app. Before starting,
[install Compose](https://docs.docker.com/compose/install/).

## Define the project components

For this project, you need to create a Dockerfile, a Python dependencies file,
and a `docker-compose.yml` file. (You can use either a `.yml` or `.yaml` extension for this file.)

1. Create an empty project directory.

    You can name the directory something easy for you to remember. This directory is the context for your application image. The directory should only contain resources to build that image.

2. Create a new file called `Dockerfile` in your project directory.

    The Dockerfile defines an application's image content via one or more build
    commands that configure that image. Once built, you can run the image in a
    container.  For more information on `Dockerfile`, see the [Docker user guide](https://docs.docker.com/get-started/)
    and the [Dockerfile reference](https://docs.docker.com/engine/reference/builder/).

3. Add the following content to the `Dockerfile`.

   ```dockerfile
   # syntax=docker/dockerfile:1
   FROM python:3
   ENV PYTHONDONTWRITEBYTECODE=1
   ENV PYTHONUNBUFFERED=1
   WORKDIR /code
   COPY requirements.txt /code/
   RUN pip install -r requirements.txt
   COPY . /code/
   ```

   This `Dockerfile` starts with a [Python 3 parent image](https://hub.docker.com/r/library/python/tags/3/).
   The parent image is modified by adding a new `code` directory. The parent image is further modified
   by installing the Python requirements defined in the `requirements.txt` file.

4. Save and close the `Dockerfile`.

5. Create a `requirements.txt` in your project directory.

    This file is used by the `RUN pip install -r requirements.txt` command in your `Dockerfile`.

6. Add the required software in the file.

    ```python
    Django>=3.0,<4.0
    psycopg2>=2.8
    ```

7. Save and close the `requirements.txt` file.

8. Create a file called `docker-compose.yml` in your project directory.

    The `docker-compose.yml` file describes the services that make your app. In
    this example those services are a web server and database.  The compose file
    also describes which Docker images these services use, how they link
    together, any volumes they might need to be mounted inside the containers.
    Finally, the `docker-compose.yml` file describes which ports these services
    expose. See the [`docker-compose.yml` reference](https://docs.docker.com/compose/compose-file/) for more
    information on how this file works.

9. Add the following configuration to the file.

   ```yaml
   services:
     db:
       image: postgres
       volumes:
         - ./data/db:/var/lib/postgresql/data
       environment:
         - POSTGRES_DB=postgres
         - POSTGRES_USER=postgres
         - POSTGRES_PASSWORD=postgres
     web:
       build: .
       command: python manage.py runserver 0.0.0.0:8000
       volumes:
         - .:/code
       ports:
         - "8000:8000"
       environment:
         - POSTGRES_NAME=postgres
         - POSTGRES_USER=postgres
         - POSTGRES_PASSWORD=postgres
       depends_on:
         - db
   ```

   This file defines two services: The `db` service and the `web` service.

   > Note:
   >
   > This uses the build in development server to run your application
   > on port 8000. Do not use this in a production environment. For more
   > information, see [Django documentation](https://docs.djangoproject.com/en/3.1/intro/tutorial01/#the-development-server){: target="_blank" rel="noopener" class="_”}.

10. Save and close the `docker-compose.yml` file.

## Create a Django project

In this step, you create a Django starter project by building the image from the build context defined in the previous procedure.

1. Change to the root of your project directory.

2. Create the Django project by running the [docker compose run](https://docs.docker.com/engine/reference/commandline/compose_run/)
   command as follows.

   ```console
   sudo docker compose run web django-admin startproject composeexample .
   ```

   This instructs Compose to run `django-admin startproject composeexample`
   in a container, using the `web` service's image and configuration. Because
   the `web` image doesn't exist yet, Compose builds it from the current
   directory, as specified by the `build: .` line in `docker-compose.yml`.

   Once the `web` service image is built, Compose runs it and executes the
   `django-admin startproject` command in the container. This command
   instructs Django to create a set of files and directories representing a
   Django project.

3. After the `docker compose` command completes, list the contents of your project.

   ```console
   $ ls -l

   drwxr-xr-x 2 root   root   composeexample
   drwxr-xr-x 3 root   root   data
   -rw-rw-r-- 1 user   user   docker-compose.yml
   -rw-rw-r-- 1 user   user   Dockerfile
   -rwxr-xr-x 1 root   root   manage.py
   -rw-rw-r-- 1 user   user   requirements.txt
   ```

   If you are running Docker on Linux, the files `django-admin` created are
   owned by root. This happens because the container runs as the root user.
   Change the ownership of the new files.

   Do not change the permission of the data folder where Postgres has its file, otherwise Postgres will not be able to start due to permission issues.

   ```console
   sudo chown -R $USER:$USER composeexample manage.py
   ```

   If you are running Docker on Mac or Windows, you should already
   have ownership of all files, including those generated by
   `django-admin`. List the files just to verify this.

   ```console
   $ ls -l

   total 32
   -rw-r--r--  1 user  staff  145 Feb 13 23:00 Dockerfile
   drwxr-xr-x  6 user  staff  204 Feb 13 23:07 composeexample
   -rw-r--r--  1 user  staff  159 Feb 13 23:02 docker-compose.yml
   -rwxr-xr-x  1 user  staff  257 Feb 13 23:07 manage.py
   -rw-r--r--  1 user  staff   16 Feb 13 23:01 requirements.txt
   ```

### Connect the database

In this section, you set up the database connection for Django.

1. In your project directory, edit the `composeexample/settings.py` file.

2. Replace the `DATABASES = ...` with the following:

   ```python
   # settings.py
   
   import os
   
   [...]
   
   DATABASES = {
       'default': {
           'ENGINE': 'django.db.backends.postgresql',
           'NAME': os.environ.get('POSTGRES_NAME'),
           'USER': os.environ.get('POSTGRES_USER'),
           'PASSWORD': os.environ.get('POSTGRES_PASSWORD'),
           'HOST': 'db',
           'PORT': 5432,
       }
   }
   ```

   These settings are determined by the
   [postgres](https://hub.docker.com/_/postgres) Docker image
   specified in `docker-compose.yml`.

3. Save and close the file.

4. Run the [docker compose up](https://docs.docker.com/engine/reference/commandline/compose_up/) command from the top level directory for your project.

   ```console
   $ docker compose up

   djangosample_db_1 is up-to-date
   Creating djangosample_web_1 ...
   Creating djangosample_web_1 ... done
   Attaching to djangosample_db_1, djangosample_web_1
   db_1   | The files belonging to this database system will be owned by user "postgres".
   db_1   | This user must also own the server process.
   db_1   |
   db_1   | The database cluster will be initialized with locale "en_US.utf8".
   db_1   | The default database encoding has accordingly been set to "UTF8".
   db_1   | The default text search configuration will be set to "english".

   <...>

   web_1  | July 30, 2020 - 18:35:38
   web_1  | Django version 3.0.8, using settings 'composeexample.settings'
   web_1  | Starting development server at http://0.0.0.0:8000/
   web_1  | Quit the server with CONTROL-C.
   ```

   At this point, your Django app should be running at port `8000` on
   your Docker host. On Docker Desktop for Mac and Docker Desktop for Windows, go
   to `http://localhost:8000` on a web browser to see the Django
   welcome page.

   ![Django example](images/django-it-worked.png)

   > Note:
   >
   > On certain platforms (Windows 10), you might need to edit `ALLOWED_HOSTS`
   > inside `settings.py` and add your Docker host name or IP address to the list.
   > For demo purposes, you can set the value to:
   >
   > ```python
   > ALLOWED_HOSTS = ['*']
   > ```
   >
   > This value is **not** safe for production usage.  Refer to the
   > [Django documentation](https://docs.djangoproject.com/en/1.11/ref/settings/#allowed-hosts)  for more information.

5. List running containers.

   In another terminal window, list the running Docker processes with the `docker ps` or `docker container ls` command.

   ```console
   $ docker ps

   CONTAINER ID  IMAGE       COMMAND                  CREATED         STATUS        PORTS                    NAMES
   def85eff5f51  django_web  "python3 manage.py..."   10 minutes ago  Up 9 minutes  0.0.0.0:8000->8000/tcp   django_web_1
   678ce61c79cc  postgres    "docker-entrypoint..."   20 minutes ago  Up 9 minutes  5432/tcp                 django_db_1
   ```

6. Shut down services and clean up by using either of these methods:

    * Stop the application by typing `Ctrl-C`  in the same shell in where you
      started it:

      ```console
      Gracefully stopping... (press Ctrl+C again to force)
      Killing test_web_1 ... done
      Killing test_db_1 ... done
      ```

    * Or, for a more elegant shutdown, switch to a different shell, and run
      [docker compose down](https://docs.docker.com/engine/reference/commandline/compose_down/) from the top level of your
      Django sample project directory.

      ```console
      $ docker compose down

      Stopping django_web_1 ... done
      Stopping django_db_1 ... done
      Removing django_web_1 ... done
      Removing django_web_run_1 ... done
      Removing django_db_1 ... done
      Removing network django_default
      ```

  Once you've shut down the app, you can safely remove the Django project directory (for example, `rm -rf django`).

## More Compose documentation

* [Docker Compose overview](https://docs.docker.com/compose/)
* [Install Docker Compose](https://docs.docker.com/compose/install/)
* [Getting Started with Docker Compose](https://docs.docker.com/compose/gettingstarted/)
* [Docker Compose Command line reference](https://docs.docker.com/compose/reference/)
* [Compose file reference](https://docs.docker.com/compose/compose-file/)
* [Awesome Compose Django sample application](../../django/README.md)

```





**Files Read:**

**/home/ophil/src/awesome-pods/django-postgres/Containerfile**
```
# syntax=docker/dockerfile:1
FROM python:3
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code/

```





**Files Read:**

**/home/ophil/src/awesome-pods/rails-postgres/README.md**
```
# Quickstart: Compose and Rails

This Quickstart guide shows you how to use Docker Compose to set up and run
a Rails/PostgreSQL app. Before starting, [install Compose](https://docs.docker.com/compose/install/).

## Define the project

Start by setting up the files needed to build the app. The app will run inside a
Docker container containing its dependencies. Defining dependencies is done using
a file called `Dockerfile`. To begin with, the  Dockerfile consists of:

```dockerfile
# syntax=docker/dockerfile:1
FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
```

That'll put your application code inside an image that builds a container
with Ruby, Bundler and all your dependencies inside it. For more information on
how to write Dockerfiles, see the [Docker user guide](https://docs.docker.com/get-started/)
and the [Dockerfile reference](https://docs.docker.com/engine/reference/builder/).

Next, open an editor and create a bootstrap `Gemfile` which just loads Rails. This will be overwritten in a moment by `rails new`.

```ruby
source 'https://rubygems.org'
gem 'rails', '~>5'
```

Create an empty `Gemfile.lock` file to build our `Dockerfile`.

```console
$ touch Gemfile.lock
```

Next, provide an entrypoint script to fix a Rails-specific issue that
prevents the server from restarting when a certain `server.pid` file pre-exists.
This script will be executed every time the container gets started.
`entrypoint.sh` consists of:

```bash
#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
```

Finally, `docker-compose.yml` is where the magic happens. This file describes
the services that comprise your app (a database and a web app), how to get each
one's Docker image (the database just runs on a pre-made PostgreSQL image, and
the web app is built from the current directory), and the configuration needed
to link them together and expose the web app's port.

```yaml
services:
  db:
    image: postgres
    volumes:
      - ./tmp/db:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: password
  web:
    build: .
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - .:/myapp
    ports:
      - "3000:3000"
    depends_on:
      - db
```

> **Tip**
>
> You can use either a `.yml` or `.yaml` extension for this file.

### Build the project

With those files in place, you can now generate the Rails skeleton app
using [docker compose run](https://docs.docker.com/engine/reference/commandline/compose_run/):

```console
$ docker compose run --no-deps web rails new . --force --database=postgresql
```

First, Compose builds the image for the `web` service using the `Dockerfile`.
The `--no-deps` tells Compose not to start linked services. Then it runs
`rails new` inside a new container, using that image. Once it's done, you
should have generated a fresh app.

List the files.

```console
$ ls -l

total 64
-rw-r--r--   1 vmb  staff   222 Jun  7 12:05 Dockerfile
-rw-r--r--   1 vmb  staff  1738 Jun  7 12:09 Gemfile
-rw-r--r--   1 vmb  staff  4297 Jun  7 12:09 Gemfile.lock
-rw-r--r--   1 vmb  staff   374 Jun  7 12:09 README.md
-rw-r--r--   1 vmb  staff   227 Jun  7 12:09 Rakefile
drwxr-xr-x  10 vmb  staff   340 Jun  7 12:09 app
drwxr-xr-x   8 vmb  staff   272 Jun  7 12:09 bin
drwxr-xr-x  14 vmb  staff   476 Jun  7 12:09 config
-rw-r--r--   1 vmb  staff   130 Jun  7 12:09 config.ru
drwxr-xr-x   3 vmb  staff   102 Jun  7 12:09 db
-rw-r--r--   1 vmb  staff   211 Jun  7 12:06 docker-compose.yml
-rw-r--r--   1 vmb  staff   184 Jun  7 12:08 entrypoint.sh
drwxr-xr-x   4 vmb  staff   136 Jun  7 12:09 lib
drwxr-xr-x   3 vmb  staff   102 Jun  7 12:09 log
-rw-r--r--   1 vmb  staff    63 Jun  7 12:09 package.json
drwxr-xr-x   9 vmb  staff   306 Jun  7 12:09 public
drwxr-xr-x   9 vmb  staff   306 Jun  7 12:09 test
drwxr-xr-x   4 vmb  staff   136 Jun  7 12:09 tmp
drwxr-xr-x   3 vmb  staff   102 Jun  7 12:09 vendor
```

If you are running Docker on Linux, the files `rails new` created are owned by
root. This happens because the container runs as the root user. If this is the
case, change the ownership of the new files.

```console
$ sudo chown -R $USER:$USER .
```

If you are running Docker on Mac or Windows, you should already have ownership
of all files, including those generated by `rails new`.

Now that you’ve got a new Gemfile, you need to build the image again. (This, and
changes to the `Gemfile` or the Dockerfile, should be the only times you’ll need
to rebuild.)

```console
$ docker compose build
```

### Connect the database

The app is now bootable, but you're not quite there yet. By default, Rails
expects a database to be running on `localhost` - so you need to point it at the
`db` container instead. You also need to change the database and username to
align with the defaults set by the `postgres` image.

Replace the contents of `config/database.yml` with the following:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: db
  username: postgres
  password: password
  pool: 5

development:
  <<: *default
  database: myapp_development


test:
  <<: *default
  database: myapp_test
```

You can now boot the app with [docker compose up](https://docs.docker.com/engine/reference/commandline/compose_up/).
If all is well, you should see some PostgreSQL output:

```console
$ docker compose up

rails_db_1 is up-to-date
Creating rails_web_1 ... done
Attaching to rails_db_1, rails_web_1
db_1   | PostgreSQL init process complete; ready for start up.
db_1   |
db_1   | 2018-03-21 20:18:37.437 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
db_1   | 2018-03-21 20:18:37.437 UTC [1] LOG:  listening on IPv6 address "::", port 5432
db_1   | 2018-03-21 20:18:37.443 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
db_1   | 2018-03-21 20:18:37.726 UTC [55] LOG:  database system was shut down at 2018-03-21 20:18:37 UTC
db_1   | 2018-03-21 20:18:37.772 UTC [1] LOG:  database system is ready to accept connections
```

Finally, you need to create the database. In another terminal, run:

```console
$ docker compose run web rake db:create
Starting rails_db_1 ... done
Created database 'myapp_development'
Created database 'myapp_test'
```

### View the Rails welcome page!

That's it. Your app should now be running on port 3000 on your Docker daemon.

On Docker Desktop for Mac and Docker Desktop for Windows, go to `http://localhost:3000` on a web
browser to see the Rails Welcome.

![Rails example](images/rails-welcome.png)

### Stop the application

To stop the application, run [docker compose down](https://docs.docker.com/engine/reference/commandline/compose_down/) in
your project directory. You can use the same terminal window in which you
started the database, or another one where you have access to a command prompt.
This is a clean way to stop the application.

```console
$ docker compose down

Stopping rails_web_1 ... done
Stopping rails_db_1 ... done
Removing rails_web_run_1 ... done
Removing rails_web_1 ... done
Removing rails_db_1 ... done
Removing network rails_default

```

### Restart the application

To restart the application run `docker compose up` in the project directory.

### Rebuild the application

If you make changes to the Gemfile or the Compose file to try out some different
configurations, you need to rebuild. Some changes require only
`docker compose up --build`, but a full rebuild requires a re-run of
`docker compose run web bundle install` to sync changes in the `Gemfile.lock` to
the host, followed by `docker compose up --build`.

Here is an example of the first case, where a full rebuild is not necessary.
Suppose you simply want to change the exposed port on the local host from `3000`
in our first example to `3001`. Make the change to the Compose file to expose
port `3000` on the container through a new port, `3001`, on the host, and save
the changes:

```yaml
ports:
  - "3001:3000"
```

Now, rebuild and restart the app with `docker compose up --build`.

Inside the container, your app is running on the same port as before `3000`, but
the Rails Welcome is now available on `http://localhost:3001` on your local
host.

## More Compose documentation

* [Docker Compose overview](https://docs.docker.com/compose/)
* [Install Docker Compose](https://docs.docker.com/compose/install/)
* [Getting Started with Docker Compose](https://docs.docker.com/compose/gettingstarted/)
* [Docker Compose Command line reference](https://docs.docker.com/compose/reference/)
* [Compose file reference](https://docs.docker.com/compose/compose-file/)

```





**Files Read:**

**/home/ophil/src/awesome-pods/spring-postgres/README.md**
```
## Compose sample application
### Java application with Spring framework and a Postgres database

Project structure:
```
.
├── backend
│   ├── Dockerfile
│   └── ...
├── db
│   └── password.txt
├── compose.yaml
└── README.md

```

[_compose.yaml_](compose.yaml)
```
services:
  backend:
    build: backend
    ports:
    - 8080:8080
  db:
    image: postgres
    ...
```
The compose file defines an application with two services `backend` and `db`.
When deploying the application, docker compose maps port 8080 of the backend service container to port 8080 of the host as specified in the file.
Make sure port 8080 on the host is not already being in use.

## Deploy with docker compose

```
$ docker compose up -d
Creating network "spring-postgres_default" with the default driver
Building backend
Step 1/11 : FROM maven:3.5-jdk-9 AS build
3.5-jdk-9: Pulling from library/maven
...
Successfully tagged spring-postgres_backend:latest
WARNING: Image for service backend was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating spring-postgres_backend_1 ... done
Creating spring-postgres_db_1      ... done
```

## Expected result

Listing containers must show two containers running and the port mapping as below:
```
$ docker ps
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                  NAMES
56236f640eaa        postgres                  "docker-entrypoint.s…"   29 seconds ago      Up 28 seconds       5432/tcp               spring-postgres_db_1
6e69472dc2c0        spring-postgres_backend   "java -Djava.securit…"   29 seconds ago      Up 28 seconds       0.0.0.0:8080->8080/tcp   spring-postgres_backend_1
```

After the application starts, navigate to `http://localhost:8080` in your web browse or run:
```
$ curl localhost:8080
<!DOCTYPE HTML>
<html>
<head>
  <title>Getting Started: Serving Web Content</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
	<p>Hello from Docker!</p>
</body>
```

Stop and remove the containers
```
$ docker compose down
Stopping spring-postgres_db_1      ... done
Stopping spring-postgres_backend_1 ... done
Removing spring-postgres_db_1      ... done
Removing spring-postgres_backend_1 ... done
Removing network spring-postgres_default
```

```





**Files Read:**

**/home/ophil/src/awesome-pods/sparkjava-mysql/README.md**
```
## Compose sample application
### Java Spark application with MySQL database

Project structure:
```
.
├── backend
│   ├── Dockerfile
│   └── ...
├── db
│   └── password.txt
├── compose.yaml
└── README.md

```

[_compose.yaml_](compose.yaml)
```
services:
  backend:
    build: backend
    ports:
    - 8080:8080
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10.6.4-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8.0.27
    ...
```
The compose file defines an application with two services `backend` and `db`.
When deploying the application, docker compose maps port 8080 of the backend service container to port 80 of the host as specified in the file.
Make sure port 8080 on the host is not already being in use.

> ℹ️ **_INFO_**  
> For compatibility purpose between `AMD64` and `ARM64` architecture, we use a MariaDB as database instead of MySQL.  
> You still can use the MySQL image by uncommenting the following line in the Compose file   
> `#image: mysql:8.0.27`

## Deploy with docker compose

```
$ docker compose up -d
Creating network "sparkjava-mysql_default" with the default driver
Building backend
...
Successfully tagged sparkjava-mysql_backend:latest
WARNING: Image for service backend was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating sparkjava-mysql_db_1      ... done
Creating sparkjava-mysql_backend_1 ... done
```

## Expected result

Listing containers must show two containers running and the port mapping as below:
```
$ docker ps
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                  NAMES
ee1e4f05d9f6        sparkjava-mysql_backend   "/bin/sh -c 'java -j…"   44 seconds ago      Up 43 seconds       0.0.0.0:8080->8080/tcp   sparkjava-mysql_backend_1
716025ddf65b        mysql:8.0.19              "docker-entrypoint.s…"   44 seconds ago      Up 43 seconds       3306/tcp, 33060/tcp    sparkjava-mysql_db_1
```

After the application starts, run:
```
$ curl localhost:8080
["Blog post #0","Blog post #1","Blog post #2","Blog post #3","Blog post #4"]
```

Stop and remove the containers
```
$ docker compose down
Stopping sparkjava-mysql_backend_1 ... done
Stopping sparkjava-mysql_db_1      ... done
Removing sparkjava-mysql_backend_1 ... done
Removing sparkjava-mysql_db_1      ... done
Removing network sparkjava-mysql_default
```

```




**Command Executed:**
```bash
cd /home/ophil/src/awesome-pods && ls django-postgres rails-postgres spring-postgres sparkjava-mysql react-nginx
```

**Output:**
```
django-postgres:
compose.yaml  Containerfile  images  make_compose  README.md

rails-postgres:
compose.yaml  Containerfile  images  make_compose  README.md

react-nginx:
compose.yaml  Dockerfile  make_compose	output.png  package.json  package-lock.json  public  README.md	src

sparkjava-mysql:
backend  compose.yaml  db  make_compose  README.md

spring-postgres:
backend  compose.yaml  db  make_compose  README.md
```



**Files Read:**

**/home/ophil/src/awesome-pods/rails-postgres/Containerfile**
```
# syntax=docker/dockerfile:1
FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]

```

**/home/ophil/src/awesome-pods/spring-postgres/backend/Dockerfile**
```
# syntax=docker/dockerfile:1.4

FROM --platform=$BUILDPLATFORM maven:3.8.5-eclipse-temurin-17 AS builder
WORKDIR /workdir/server
COPY pom.xml /workdir/server/pom.xml
RUN mvn dependency:go-offline

COPY src /workdir/server/src
RUN mvn install

FROM builder AS dev-envs
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD ["mvn", "spring-boot:run"]

FROM builder as prepare-production
RUN mkdir -p target/dependency
WORKDIR /workdir/server/target/dependency
RUN jar -xf ../*.jar

FROM eclipse-temurin:17-jre-focal

EXPOSE 8080
VOLUME /tmp
ARG DEPENDENCY=/workdir/server/target/dependency
COPY --from=prepare-production ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=prepare-production ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=prepare-production ${DEPENDENCY}/BOOT-INF/classes /app
ENTRYPOINT ["java","-cp","app:app/lib/*","com.company.project.Application"]

```

**/home/ophil/src/awesome-pods/sparkjava-mysql/backend/Dockerfile**
```
# syntax=docker/dockerfile:1.4

FROM --platform=$BUILDPLATFORM maven:3.8.5-eclipse-temurin-17 AS build
WORKDIR /workdir/server
COPY pom.xml /workdir/server/pom.xml
RUN mvn dependency:go-offline

COPY src /workdir/server/src

RUN mvn --batch-mode clean compile assembly:single

FROM build AS dev-envs
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD ["java", "-jar", "target/app.jar" ]

FROM eclipse-temurin:17-jre-focal
ARG DEPENDENCY=/workdir/server/target
EXPOSE 8080
COPY --from=build ${DEPENDENCY}/app.jar /app.jar
CMD java -jar /app.jar

```

**/home/ophil/src/awesome-pods/react-nginx/Dockerfile**
```
# syntax=docker/dockerfile:1.4

# 1. For build React app
FROM node:lts AS development

# Set working directory
WORKDIR /app

# 
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

# Same as npm install
RUN npm ci

COPY . /app

ENV CI=true
ENV PORT=3000

CMD [ "npm", "start" ]

FROM development AS build

RUN npm run build


FROM development as dev-envs
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD [ "npm", "start" ]

# 2. For Nginx setup
FROM nginx:alpine

# Copy config nginx
COPY --from=build /app/.nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy static assets from builder stage
COPY --from=build /app/build .

# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]


```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/django-postgres/kube.yaml
+++ /home/ophil/src/awesome-pods/django-postgres/kube.yaml
@@ -0,0 +1,49 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: django-postgres
+  labels:
+    app: django-postgres
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: postgres
+      env:
+        - name: POSTGRES_DB
+          value: "postgres"
+        - name: POSTGRES_USER
+          value: "postgres"
+        - name: POSTGRES_PASSWORD
+          value: "postgres"
+      ports:
+        - containerPort: 5432
+      volumeMounts:
+        - name: db-data
+          mountPath: /var/lib/postgresql/data
+    - name: web
+      image: django-postgres-app
+      command:
+        - python
+        - manage.py
+        - runserver
+        - 0.0.0.0:8000
+      env:
+        - name: POSTGRES_NAME
+          value: "postgres"
+        - name: POSTGRES_USER
+          value: "postgres"
+        - name: POSTGRES_PASSWORD
+          value: "postgres"
+      ports:
+        - containerPort: 8000
+          hostPort: 8000
+      livenessProbe:
+        httpGet:
+          path: /
+          port: 8000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+  volumes:
+    - name: db-data
+      emptyDir: {}

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/rails-postgres/kube.yaml
+++ /home/ophil/src/awesome-pods/rails-postgres/kube.yaml
@@ -0,0 +1,37 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: rails-postgres
+  labels:
+    app: rails-postgres
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: postgres
+      env:
+        - name: POSTGRES_PASSWORD
+          value: "password"
+      ports:
+        - containerPort: 5432
+      volumeMounts:
+        - name: db-data
+          mountPath: /var/lib/postgresql/data
+    - name: web
+      image: rails-postgres-app
+      command:
+        - bash
+        - -c
+        - "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
+      ports:
+        - containerPort: 3000
+          hostPort: 3000
+      livenessProbe:
+        httpGet:
+          path: /
+          port: 3000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+  volumes:
+    - name: db-data
+      emptyDir: {}

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/spring-postgres/kube.yaml
+++ /home/ophil/src/awesome-pods/spring-postgres/kube.yaml
@@ -0,0 +1,40 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: spring-postgres
+  labels:
+    app: spring-postgres
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: postgres
+      env:
+        - name: POSTGRES_DB
+          value: "example"
+        - name: POSTGRES_USER
+          value: "postgres"
+        - name: POSTGRES_PASSWORD
+          value: "example"
+      ports:
+        - containerPort: 5432
+      volumeMounts:
+        - name: db-data
+          mountPath: /var/lib/postgresql/data
+    - name: backend
+      image: spring-postgres-backend
+      env:
+        - name: POSTGRES_DB
+          value: "example"
+      ports:
+        - containerPort: 8080
+          hostPort: 8080
+      livenessProbe:
+        httpGet:
+          path: /
+          port: 8080
+        initialDelaySeconds: 10
+        periodSeconds: 30
+  volumes:
+    - name: db-data
+      emptyDir: {}

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/sparkjava-mysql/kube.yaml
+++ /home/ophil/src/awesome-pods/sparkjava-mysql/kube.yaml
@@ -0,0 +1,35 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: sparkjava-mysql
+  labels:
+    app: sparkjava-mysql
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: mariadb:10.6.4-focal
+      env:
+        - name: MYSQL_DATABASE
+          value: "example"
+        - name: MYSQL_ROOT_PASSWORD
+          value: "example"
+      ports:
+        - containerPort: 3306
+      volumeMounts:
+        - name: db-data
+          mountPath: /var/lib/mysql
+    - name: backend
+      image: sparkjava-mysql-backend
+      ports:
+        - containerPort: 8080
+          hostPort: 8080
+      livenessProbe:
+        httpGet:
+          path: /
+          port: 8080
+        initialDelaySeconds: 10
+        periodSeconds: 30
+  volumes:
+    - name: db-data
+      emptyDir: {}

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/react-nginx/kube.yaml
+++ /home/ophil/src/awesome-pods/react-nginx/kube.yaml
@@ -0,0 +1,20 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: react-nginx
+  labels:
+    app: react-nginx
+spec:
+  restartPolicy: Always
+  containers:
+    - name: frontend
+      image: react-nginx-frontend
+      ports:
+        - containerPort: 80
+          hostPort: 80
+      livenessProbe:
+        httpGet:
+          path: /
+          port: 80
+        initialDelaySeconds: 10
+        periodSeconds: 30

```



I’ve added `kube.yaml` manifests for several more samples and kept them aligned with your existing patterns (`flask`, `fastapi`, `sparkjava`, `wordpress-mysql`, `gitea-postgres`), using `podman kube play`–friendly options.

Below is what was created and how to run each.

---

## 1. `django-postgres/kube.yaml`

```yaml path="/home/ophil/src/awesome-pods/django-postgres/kube.yaml" start=1 end=49
apiVersion: v1
kind: Pod
metadata:
  name: django-postgres
  labels:
    app: django-postgres
spec:
  restartPolicy: Always
  containers:
    - name: db
      image: postgres
      env:
        - name: POSTGRES_DB
          value: "postgres"
        - name: POSTGRES_USER
          value: "postgres"
        - name: POSTGRES_PASSWORD
          value: "postgres"
      ports:
        - containerPort: 5432
      volumeMounts:
        - name: db-data
          mountPath: /var/lib/postgresql/data
    - name: web
      image: django-postgres-app
      command:
        - python
        - manage.py
        - runserver
        - 0.0.0.0:8000
      env:
        - name: POSTGRES_NAME
          value: "postgres"
        - name: POSTGRES_USER
          value: "postgres"
        - name: POSTGRES_PASSWORD
          value: "postgres"
      ports:
        - containerPort: 8000
          hostPort: 8000
      livenessProbe:
        httpGet:
          path: /
          port: 8000
        initialDelaySeconds: 10
        periodSeconds: 30
  volumes:
    - name: db-data
      emptyDir: {}
```
Build & run:

```bash
cd django-postgres
podman build -t django-postgres-app -f Containerfile .
podman kube play kube.yaml
# later
podman kube down kube.yaml
```
---

## 2. `rails-postgres/kube.yaml`

```yaml path="/home/ophil/src/awesome-pods/rails-postgres/kube.yaml" start=1 end=37
apiVersion: v1
kind: Pod
metadata:
  name: rails-postgres
  labels:
    app: rails-postgres
spec:
  restartPolicy: Always
  containers:
    - name: db
      image: postgres
      env:
        - name: POSTGRES_PASSWORD
          value: "password"
      ports:
        - containerPort: 5432
      volumeMounts:
        - name: db-data
          mountPath: /var/lib/postgresql/data
    - name: web
      image: rails-postgres-app
      command:
        - bash
        - -c
        - "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
      ports:
        - containerPort: 3000
          hostPort: 3000
      livenessProbe:
        httpGet:
          path: /
          port: 3000
        initialDelaySeconds: 10
        periodSeconds: 30
  volumes:
    - name: db-data
      emptyDir: {}
```
Build & run:

```bash
cd rails-postgres
podman build -t rails-postgres-app -f Containerfile .
podman kube play kube.yaml
# later
podman kube down kube.yaml
```
---

## 3. `spring-postgres/kube.yaml`

```yaml path="/home/ophil/src/awesome-pods/spring-postgres/kube.yaml" start=1 end=40
apiVersion: v1
kind: Pod
metadata:
  name: spring-postgres
  labels:
    app: spring-postgres
spec:
  restartPolicy: Always
  containers:
    - name: db
      image: postgres
      env:
        - name: POSTGRES_DB
          value: "example"
        - name: POSTGRES_USER
          value: "postgres"
        - name: POSTGRES_PASSWORD
          value: "example"
      ports:
        - containerPort: 5432
      volumeMounts:
        - name: db-data
          mountPath: /var/lib/postgresql/data
    - name: backend
      image: spring-postgres-backend
      env:
        - name: POSTGRES_DB
          value: "example"
      ports:
        - containerPort: 8080
          hostPort: 8080
      livenessProbe:
        httpGet:
          path: /
          port: 8080
        initialDelaySeconds: 10
        periodSeconds: 30
  volumes:
    - name: db-data
      emptyDir: {}
```
Build & run:

```bash
cd spring-postgres
podman build -t spring-postgres-backend backend
podman kube play kube.yaml
# later
podman kube down kube.yaml
```
---

## 4. `sparkjava-mysql/kube.yaml`

```yaml path="/home/ophil/src/awesome-pods/sparkjava-mysql/kube.yaml" start=1 end=35
apiVersion: v1
kind: Pod
metadata:
  name: sparkjava-mysql
  labels:
    app: sparkjava-mysql
spec:
  restartPolicy: Always
  containers:
    - name: db
      image: mariadb:10.6.4-focal
      env:
        - name: MYSQL_DATABASE
          value: "example"
        - name: MYSQL_ROOT_PASSWORD
          value: "example"
      ports:
        - containerPort: 3306
      volumeMounts:
        - name: db-data
          mountPath: /var/lib/mysql
    - name: backend
      image: sparkjava-mysql-backend
      ports:
        - containerPort: 8080
          hostPort: 8080
      livenessProbe:
        httpGet:
          path: /
          port: 8080
        initialDelaySeconds: 10
        periodSeconds: 30
  volumes:
    - name: db-data
      emptyDir: {}
```
Build & run:

```bash
cd sparkjava-mysql
podman build -t sparkjava-mysql-backend backend
podman kube play kube.yaml
# later
podman kube down kube.yaml
```
---

## 5. `react-nginx/kube.yaml`

```yaml path="/home/ophil/src/awesome-pods/react-nginx/kube.yaml" start=1 end=20
apiVersion: v1
kind: Pod
metadata:
  name: react-nginx
  labels:
    app: react-nginx
spec:
  restartPolicy: Always
  containers:
    - name: frontend
      image: react-nginx-frontend
      ports:
        - containerPort: 80
          hostPort: 80
      livenessProbe:
        httpGet:
          path: /
          port: 80
        initialDelaySeconds: 10
        periodSeconds: 30
```
Build & run:

```bash
cd react-nginx
podman build -t react-nginx-frontend .
podman kube play kube.yaml
# later
podman kube down kube.yaml
```
---

### Notes on patterns / best practices applied

- **Single Pod per sample**, mirroring compose service groupings.
- **Host ports only where Compose exposed them** (e.g. 8000, 3000, 8080, 80).
- **Ephemeral dev storage** via `emptyDir: {}` for DB data, matching other samples’ pattern.
- **HTTP liveness probes** on all HTTP-facing containers using `/` and the relevant port.
- **Images tagged per sample** (`*-app`, `*-backend`, `*-frontend`) so they’re easy to build with `podman build`.

Next, I can continue with the remaining multi-service stacks (`react-*` with DBs, `nginx-*`, `nextcloud-*`, `elasticsearch-logstash-kibana`, `prometheus-grafana`, `postgresql-pgadmin`, `pihole-cloudflared-DoH`, `wasmedge-*`).  

Do you prefer I tackle a specific group next (e.g. all `react-*` or all `nginx-*`), or keep going in this mixed order?

USER:
keep going in this mixed order

AGENT:


**Files Read:**

**/home/ophil/src/awesome-pods/elasticsearch-logstash-kibana/compose.yaml**
```
services:
  elasticsearch:
    image: elasticsearch:7.16.1
    container_name: es
    environment:
      discovery.type: single-node
      ES_JAVA_OPTS: "-Xms512m -Xmx512m"
    ports:
      - "9200:9200"
      - "9300:9300"
    healthcheck:
      test: ["CMD-SHELL", "curl --silent --fail localhost:9200/_cluster/health || exit 1"]
      interval: 10s
      timeout: 10s
      retries: 3
    networks:
      - elastic
  logstash:
    image: logstash:7.16.1
    container_name: log
    environment:
      discovery.seed_hosts: logstash
      LS_JAVA_OPTS: "-Xms512m -Xmx512m"
    volumes:
      - ./logstash/pipeline/logstash-nginx.config:/usr/share/logstash/pipeline/logstash-nginx.config
      - ./logstash/nginx.log:/home/nginx.log
    ports:
      - "5000:5000/tcp"
      - "5000:5000/udp"
      - "5044:5044"
      - "9600:9600"
    depends_on:
      - elasticsearch
    networks:
      - elastic
    command: logstash -f /usr/share/logstash/pipeline/logstash-nginx.config
  kibana:
    image: kibana:7.16.1
    container_name: kib
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
    networks:
      - elastic
networks:
  elastic:
    driver: bridge

```

**/home/ophil/src/awesome-pods/elasticsearch-logstash-kibana/README.md**
```
## Compose sample application
### Elasticsearch, Logstash, and Kibana (ELK) in single-node

Project structure:
```
.
└── compose.yaml
```

[_compose.yaml_](compose.yaml)
```
services:
  elasticsearch:
    image: elasticsearch:7.8.0
    ...
  logstash:
    image: logstash:7.8.0
    ...
  kibana:
    image: kibana:7.8.0
    ...
```

## Deploy with docker compose

```
$ docker compose up -d
Creating network "elasticsearch-logstash-kibana_elastic" with driver "bridge"
Creating es ... done
Creating log ... done
Creating kib ... done
```

## Expected result

Listing containers must show three containers running and the port mapping as below:
```
$ docker ps
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS                    PORTS                                                                                            NAMES
173f0634ed33        logstash:7.8.0        "/usr/local/bin/dock…"   43 seconds ago      Up 41 seconds             0.0.0.0:5000->5000/tcp, 0.0.0.0:5044->5044/tcp, 0.0.0.0:9600->9600/tcp, 0.0.0.0:5000->5000/udp   log
b448fd3e9b30        kibana:7.8.0          "/usr/local/bin/dumb…"   43 seconds ago      Up 42 seconds             0.0.0.0:5601->5601/tcp                                                                           kib
366d358fb03d        elasticsearch:7.8.0   "/tini -- /usr/local…"   43 seconds ago      Up 42 seconds (healthy)   0.0.0.0:9200->9200/tcp, 0.0.0.0:9300->9300/tcp                                                   es
```

After the application starts, navigate to below links in your web browser:

* Elasticsearch: [`http://localhost:9200`](http://localhost:9200)
* Logstash: [`http://localhost:9600`](http://localhost:9600)
* Kibana: [`http://localhost:5601/api/status`](http://localhost:5601/api/status)

Stop and remove the containers
```
$ docker compose down
```

## Attribution

The [example Nginx logs](https://github.com/docker/awesome-compose/tree/master/elasticsearch-logstash-kibana/logstash/nginx.log) are copied from [here](https://github.com/elastic/examples/blob/master/Common%20Data%20Formats/nginx_json_logs/nginx_json_logs).

```

**/home/ophil/src/awesome-pods/nextcloud-postgres/compose.yaml**
```
services:
  nc:
    image: nextcloud:apache
    environment:
      - POSTGRES_HOST=db
      - POSTGRES_PASSWORD=nextcloud
      - POSTGRES_DB=nextcloud
      - POSTGRES_USER=nextcloud
    ports:
      - 80:80
    restart: always
    volumes:
      - nc_data:/var/www/html
  db:
    image: postgres:alpine
    environment:
      - POSTGRES_PASSWORD=nextcloud
      - POSTGRES_DB=nextcloud
      - POSTGRES_USER=nextcloud
    restart: always
    volumes:
      - db_data:/var/lib/postgresql/data
    expose:
      - 5432
volumes:
  db_data:
  nc_data:

```

**/home/ophil/src/awesome-pods/nextcloud-postgres/README.md**
```
## Nextcloud with Postgres database
This example defines one of the base setups for Nextcloud. More details on how to
further customize the installation and the compose file can be found on the
[official image page](https://hub.docker.com/_/nextcloud).


Project structure:
```
.
├── compose.yaml
└── README.md
```

[_compose.yaml_](compose.yaml)
```
services:
  nc:
    image: nextcloud:apache
    ports:
      - 80:80
    ...
  db:
    image: postgres:alpine
    ...
```

When deploying this setup, docker compose maps the nextcloud container port 80 to
port 80 of the host as specified in the compose file.

## Deploy with docker compose

```
$ docker compose up -d
Creating network "nextcloud-postgres_default" with the default driver
Creating volume "nextcloud-postgres_nc_data" with default driver
Pulling nc (nextcloud:apache)...
....
....
Status: Downloaded newer image for postgres:alpine
Creating nextcloud-postgres_nc_1 ... done
Creating nextcloud-postgres_db_1 ... done
```


## Expected result

Check containers are running and the port mapping:
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
9884a9cc0144        postgres:alpine     "docker-entrypoint.s…"   12 minutes ago      Up 12 minutes       5432/tcp             nextcloud-postgres_db_1
bae385bee48b        nextcloud:apache    "/entrypoint.sh apac…"   12 minutes ago      Up 12 minutes       0.0.0.0:80->80/tcp   nextcloud-postgres_nc_1
```

Navigate to `http://localhost:80` in your web browser to access the installed
Nextcloud service.

![page](output.jpg)

Stop and remove the containers

```
$ docker compose down
```

```

**/home/ophil/src/awesome-pods/postgresql-pgadmin/compose.yaml**
```
services:
  postgres:
    container_name: postgres
    image: postgres:latest
    environment:
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PW}
      - POSTGRES_DB=${POSTGRES_DB} #optional (specify default database instead of $POSTGRES_DB)
    ports:
      - "5432:5432"
    restart: always

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      - PGADMIN_DEFAULT_EMAIL=${PGADMIN_MAIL}
      - PGADMIN_DEFAULT_PASSWORD=${PGADMIN_PW}
    ports:
      - "5050:80"
    restart: always

```

**/home/ophil/src/awesome-pods/postgresql-pgadmin/README.md**
```
## PostgreSQL and pgAdmin
This example provides a base setup for using [PostgreSQL](https://www.postgresql.org/) and [pgAdmin](https://www.pgadmin.org/).
More details on how to customize the installation and the compose file can be found [here (PostgreSQL)](https://hub.docker.com/_/postgres) and [here (pgAdmin)](https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html).

Project structure:
```
.
├── .env
├── compose.yaml
└── README.md
```

[_compose.yaml_](compose.yaml)
``` yaml
services:
  postgres:
    image: postgres:latest
    ...
  pgadmin:
    image: dpage/pgadmin4:latest
```

## Configuration

### .env
Before deploying this setup, you need to configure the following values in the [.env](.env) file.
- POSTGRES_USER
- POSTGRES_PW
- POSTGRES_DB (can be default value)
- PGADMIN_MAIL
- PGADMIN_PW

## Deploy with docker compose
When deploying this setup, the pgAdmin web interface will be available at port 5050 (e.g. http://localhost:5050).  

``` shell
$ docker compose up
Starting postgres ... done
Starting pgadmin ... done
```

## Add postgres database to pgAdmin
After logging in with your credentials of the .env file, you can add your database to pgAdmin. 
1. Right-click "Servers" in the top-left corner and select "Create" -> "Server..."
2. Name your connection
3. Change to the "Connection" tab and add the connection details:
- Hostname: "postgres" (this would normally be your IP address of the postgres database - however, docker can resolve this container ip by its name)
- Port: "5432"
- Maintenance Database: $POSTGRES_DB (see .env)
- Username: $POSTGRES_USER (see .env)
- Password: $POSTGRES_PW (see .env)
  
## Expected result

Check containers are running:
```
$ docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED             STATUS                 PORTS                                                                                  NAMES
849c5f48f784   postgres:latest                 "docker-entrypoint.s…"   9 minutes ago       Up 9 minutes           0.0.0.0:5432->5432/tcp, :::5432->5432/tcp                                              postgres
d3cde3b455ee   dpage/pgadmin4:latest           "/entrypoint.sh"         9 minutes ago       Up 9 minutes           443/tcp, 0.0.0.0:5050->80/tcp, :::5050->80/tcp                                         pgadmin
```

Stop the containers with
``` shell
$ docker compose down
# To delete all data run:
$ docker compose down -v
```

```

**/home/ophil/src/awesome-pods/prometheus-grafana/compose.yaml**
```
services:
  prometheus:
    image: prom/prometheus
    container_name: prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    ports:
      - 9090:9090
    restart: unless-stopped
    volumes:
      - ./prometheus:/etc/prometheus
      - prom_data:/prometheus
  grafana:
    image: grafana/grafana
    container_name: grafana
    ports:
      - 3000:3000
    restart: unless-stopped
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=grafana
    volumes:
      - ./grafana:/etc/grafana/provisioning/datasources
volumes:
  prom_data:

```

**/home/ophil/src/awesome-pods/prometheus-grafana/README.md**
```
## Compose sample
### Prometheus & Grafana

Project structure:
```
.
├── compose.yaml
├── grafana
│   └── datasource.yml
├── prometheus
│   └── prometheus.yml
└── README.md
```

[_compose.yaml_](compose.yaml)
```
services:
  prometheus:
    image: prom/prometheus
    ...
    ports:
      - 9090:9090
  grafana:
    image: grafana/grafana
    ...
    ports:
      - 3000:3000
```
The compose file defines a stack with two services `prometheus` and `grafana`.
When deploying the stack, docker compose maps port the default ports for each service to the equivalent ports on the host in order to inspect easier the web interface of each service.
Make sure the ports 9090 and 3000 on the host are not already in use.

## Deploy with docker compose

```
$ docker compose up -d
Creating network "prometheus-grafana_default" with the default driver
Creating volume "prometheus-grafana_prom_data" with default driver
...
Creating grafana    ... done
Creating prometheus ... done
Attaching to prometheus, grafana

```

## Expected result

Listing containers must show two containers running and the port mapping as below:
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
dbdec637814f        prom/prometheus     "/bin/prometheus --c…"   8 minutes ago       Up 8 minutes        0.0.0.0:9090->9090/tcp   prometheus
79f667cb7dc2        grafana/grafana     "/run.sh"                8 minutes ago       Up 8 minutes        0.0.0.0:3000->3000/tcp   grafana
```

Navigate to `http://localhost:3000` in your web browser and use the login credentials specified in the compose file to access Grafana. It is already configured with prometheus as the default datasource.

![page](output.jpg)

Navigate to `http://localhost:9090` in your web browser to access directly the web interface of prometheus.

Stop and remove the containers. Use `-v` to remove the volumes if looking to erase all data.
```
$ docker compose down -v
```

```

**/home/ophil/src/awesome-pods/nginx-flask-mysql/compose.yaml**
```
services:
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8
    command: '--default-authentication-plugin=mysql_native_password'
    restart: always
    healthcheck:
      test: ['CMD-SHELL', 'mysqladmin ping -h 127.0.0.1 --password="$$(cat /run/secrets/db-password)" --silent']
      interval: 3s
      retries: 5
      start_period: 30s
    secrets:
      - db-password
    volumes:
      - db-data:/var/lib/mysql
    networks:
      - backnet
    environment:
      - MYSQL_DATABASE=example
      - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db-password
    expose:
      - 3306
      - 33060

  backend:
    build:
      context: backend
      target: builder
    restart: always
    secrets:
      - db-password
    ports:
      - 8000:8000
    networks:
      - backnet
      - frontnet
    depends_on:
      db:
        condition: service_healthy

  proxy:
    build: proxy
    restart: always
    ports:
      - 80:80
    depends_on: 
      - backend
    networks:
      - frontnet

volumes:
  db-data:

secrets:
  db-password:
    file: db/password.txt

networks:
  backnet:
  frontnet:

```

**/home/ophil/src/awesome-pods/nginx-flask-mysql/README.md**
```
## Compose sample application
### Python/Flask with Nginx proxy and MySQL database

Project structure:
```
.
├── compose.yaml
├── flask
│   ├── Dockerfile
│   ├── requirements.txt
│   └── server.py
└── nginx
    └── nginx.conf

```

[_compose.yaml_](compose.yaml)
```
services:
  backend:
    build:
      context: backend
      target: builder
    ...
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8
    ...
  proxy:
    build: proxy
    ...
```
The compose file defines an application with three services `proxy`, `backend` and `db`.
When deploying the application, docker compose maps port 80 of the proxy service container to port 80 of the host as specified in the file.
Make sure port 80 on the host is not already being in use.

> ℹ️ **_INFO_**  
> For compatibility purpose between `AMD64` and `ARM64` architecture, we use a MariaDB as database instead of MySQL.  
> You still can use the MySQL image by uncommenting the following line in the Compose file   
> `#image: mysql:8`

## Deploy with docker compose

```
$ docker compose up -d
Creating network "nginx-flask-mysql_default" with the default driver
Pulling db (mysql:8.0.19)...
5.7: Pulling from library/mysql
...
...
WARNING: Image for service proxy was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating nginx-flask-mysql_db_1 ... done
Creating nginx-flask-mysql_backend_1 ... done
Creating nginx-flask-mysql_proxy_1   ... done
```

## Expected result

Listing containers should show three containers running and the port mapping as below:
```
$ docker compose ps
NAME                          COMMAND                  SERVICE             STATUS              PORTS
nginx-flask-mysql-backend-1   "flask run"              backend             running             0.0.0.0:8000->8000/tcp
nginx-flask-mysql-db-1        "docker-entrypoint.s…"   db                  running (healthy)   3306/tcp, 33060/tcp
nginx-flask-mysql-proxy-1     "nginx -g 'daemon of…"   proxy               running             0.0.0.0:80->80/tcp
```

After the application starts, navigate to `http://localhost:80` in your web browser or run:
```
$ curl localhost:80
<div>Blog post #1</div><div>Blog post #2</div><div>Blog post #3</div><div>Blog post #4</div>
```

Stop and remove the containers
```
$ docker compose down
```

```



Creating and wiring manifests now for a few more mixed samples (ELK, Nextcloud+Postgres, PostgreSQL+pgAdmin, Prometheus+Grafana, nginx+Flask+MySQL), following the same pod patterns and then I’ll summarize and give run commands.


**Diff:**
```diff
--- /home/ophil/src/awesome-pods/elasticsearch-logstash-kibana/kube.yaml
+++ /home/ophil/src/awesome-pods/elasticsearch-logstash-kibana/kube.yaml
@@ -0,0 +1,64 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: elk
+  labels:
+    app: elk
+spec:
+  restartPolicy: Always
+  containers:
+    - name: elasticsearch
+      image: elasticsearch:7.16.1
+      env:
+        - name: discovery.type
+          value: single-node
+        - name: ES_JAVA_OPTS
+          value: "-Xms512m -Xmx512m"
+      ports:
+        - containerPort: 9200
+          hostPort: 9200
+        - containerPort: 9300
+          hostPort: 9300
+      livenessProbe:
+        httpGet:
+          path: /_cluster/health
+          port: 9200
+        initialDelaySeconds: 20
+        periodSeconds: 30
+    - name: logstash
+      image: logstash:7.16.1
+      env:
+        - name: discovery.seed_hosts
+          value: logstash
+        - name: LS_JAVA_OPTS
+          value: "-Xms512m -Xmx512m"
+      command:
+        - logstash
+        - -f
+        - /usr/share/logstash/pipeline/logstash-nginx.config
+      ports:
+        - containerPort: 5000
+          hostPort: 5000
+        - containerPort: 5044
+          hostPort: 5044
+        - containerPort: 9600
+          hostPort: 9600
+      volumeMounts:
+        - name: logstash-pipeline
+          mountPath: /usr/share/logstash/pipeline/logstash-nginx.config
+          subPath: logstash-nginx.config
+        - name: logstash-nginx-log
+          mountPath: /home/nginx.log
+          subPath: nginx.log
+    - name: kibana
+      image: kibana:7.16.1
+      ports:
+        - containerPort: 5601
+          hostPort: 5601
+  volumes:
+    - name: logstash-pipeline
+      hostPath:
+        path: ./logstash/pipeline
+    - name: logstash-nginx-log
+      hostPath:
+        path: ./logstash

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/nextcloud-postgres/kube.yaml
+++ /home/ophil/src/awesome-pods/nextcloud-postgres/kube.yaml
@@ -0,0 +1,45 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: nextcloud-postgres
+  labels:
+    app: nextcloud-postgres
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: postgres:alpine
+      env:
+        - name: POSTGRES_PASSWORD
+          value: "nextcloud"
+        - name: POSTGRES_DB
+          value: "nextcloud"
+        - name: POSTGRES_USER
+          value: "nextcloud"
+      ports:
+        - containerPort: 5432
+      volumeMounts:
+        - name: db-data
+          mountPath: /var/lib/postgresql/data
+    - name: nc
+      image: nextcloud:apache
+      env:
+        - name: POSTGRES_HOST
+          value: "db"
+        - name: POSTGRES_PASSWORD
+          value: "nextcloud"
+        - name: POSTGRES_DB
+          value: "nextcloud"
+        - name: POSTGRES_USER
+          value: "nextcloud"
+      ports:
+        - containerPort: 80
+          hostPort: 80
+      volumeMounts:
+        - name: nc-data
+          mountPath: /var/www/html
+  volumes:
+    - name: db-data
+      emptyDir: {}
+    - name: nc-data
+      emptyDir: {}

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/postgresql-pgadmin/kube.yaml
+++ /home/ophil/src/awesome-pods/postgresql-pgadmin/kube.yaml
@@ -0,0 +1,46 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: postgresql-pgadmin
+  labels:
+    app: postgresql-pgadmin
+spec:
+  restartPolicy: Always
+  containers:
+    - name: postgres
+      image: postgres:latest
+      env:
+        - name: POSTGRES_USER
+          valueFrom:
+            secretKeyRef:
+              name: postgres-env
+              key: POSTGRES_USER
+        - name: POSTGRES_PASSWORD
+          valueFrom:
+            secretKeyRef:
+              name: postgres-env
+              key: POSTGRES_PW
+        - name: POSTGRES_DB
+          valueFrom:
+            secretKeyRef:
+              name: postgres-env
+              key: POSTGRES_DB
+      ports:
+        - containerPort: 5432
+          hostPort: 5432
+    - name: pgadmin
+      image: dpage/pgadmin4:latest
+      env:
+        - name: PGADMIN_DEFAULT_EMAIL
+          valueFrom:
+            secretKeyRef:
+              name: postgres-env
+              key: PGADMIN_MAIL
+        - name: PGADMIN_DEFAULT_PASSWORD
+          valueFrom:
+            secretKeyRef:
+              name: postgres-env
+              key: PGADMIN_PW
+      ports:
+        - containerPort: 80
+          hostPort: 5050

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/prometheus-grafana/kube.yaml
+++ /home/ophil/src/awesome-pods/prometheus-grafana/kube.yaml
@@ -0,0 +1,43 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: prometheus-grafana
+  labels:
+    app: prometheus-grafana
+spec:
+  restartPolicy: Always
+  containers:
+    - name: prometheus
+      image: prom/prometheus
+      args:
+        - '--config.file=/etc/prometheus/prometheus.yml'
+      ports:
+        - containerPort: 9090
+          hostPort: 9090
+      volumeMounts:
+        - name: prom-config
+          mountPath: /etc/prometheus
+        - name: prom-data
+          mountPath: /prometheus
+    - name: grafana
+      image: grafana/grafana
+      env:
+        - name: GF_SECURITY_ADMIN_USER
+          value: 'admin'
+        - name: GF_SECURITY_ADMIN_PASSWORD
+          value: 'grafana'
+      ports:
+        - containerPort: 3000
+          hostPort: 3000
+      volumeMounts:
+        - name: grafana-config
+          mountPath: /etc/grafana/provisioning/datasources
+  volumes:
+    - name: prom-config
+      hostPath:
+        path: ./prometheus
+    - name: prom-data
+      emptyDir: {}
+    - name: grafana-config
+      hostPath:
+        path: ./grafana

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/nginx-flask-mysql/kube.yaml
+++ /home/ophil/src/awesome-pods/nginx-flask-mysql/kube.yaml
@@ -0,0 +1,42 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: nginx-flask-mysql
+  labels:
+    app: nginx-flask-mysql
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: mariadb:10-focal
+      args:
+        - '--default-authentication-plugin=mysql_native_password'
+      env:
+        - name: MYSQL_DATABASE
+          value: 'example'
+        - name: MYSQL_ROOT_PASSWORD
+          value: 'example'
+      ports:
+        - containerPort: 3306
+      volumeMounts:
+        - name: db-data
+          mountPath: /var/lib/mysql
+    - name: backend
+      image: nginx-flask-backend
+      ports:
+        - containerPort: 8000
+          hostPort: 8000
+      livenessProbe:
+        httpGet:
+          path: /
+          port: 8000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: proxy
+      image: nginx-flask-proxy
+      ports:
+        - containerPort: 80
+          hostPort: 80
+  volumes:
+    - name: db-data
+      emptyDir: {}

```



Here’s the next mixed batch of `kube.yaml` manifests I’ve added, plus how to run each with `podman kube play`.

---

## 1. `elasticsearch-logstash-kibana/kube.yaml`

```yaml path="/home/ophil/src/awesome-pods/elasticsearch-logstash-kibana/kube.yaml" start=1 end=64
apiVersion: v1
kind: Pod
metadata:
  name: elk
  labels:
    app: elk
spec:
  restartPolicy: Always
  containers:
    - name: elasticsearch
      image: elasticsearch:7.16.1
      env:
        - name: discovery.type
          value: single-node
        - name: ES_JAVA_OPTS
          value: "-Xms512m -Xmx512m"
      ports:
        - containerPort: 9200
          hostPort: 9200
        - containerPort: 9300
          hostPort: 9300
      livenessProbe:
        httpGet:
          path: /_cluster/health
          port: 9200
        initialDelaySeconds: 20
        periodSeconds: 30
    - name: logstash
      image: logstash:7.16.1
      env:
        - name: discovery.seed_hosts
          value: logstash
        - name: LS_JAVA_OPTS
          value: "-Xms512m -Xmx512m"
      command:
        - logstash
        - -f
        - /usr/share/logstash/pipeline/logstash-nginx.config
      ports:
        - containerPort: 5000
          hostPort: 5000
        - containerPort: 5044
          hostPort: 5044
        - containerPort: 9600
          hostPort: 9600
      volumeMounts:
        - name: logstash-pipeline
          mountPath: /usr/share/logstash/pipeline/logstash-nginx.config
          subPath: logstash-nginx.config
        - name: logstash-nginx-log
          mountPath: /home/nginx.log
          subPath: nginx.log
    - name: kibana
      image: kibana:7.16.1
      ports:
        - containerPort: 5601
          hostPort: 5601
  volumes:
    - name: logstash-pipeline
      hostPath:
        path: ./logstash/pipeline
    - name: logstash-nginx-log
      hostPath:
        path: ./logstash
```
Run:

```bash
cd elasticsearch-logstash-kibana
podman kube play kube.yaml
# later
podman kube down kube.yaml
```
---

## 2. `nextcloud-postgres/kube.yaml`

```yaml path="/home/ophil/src/awesome-pods/nextcloud-postgres/kube.yaml" start=1 end=45
apiVersion: v1
kind: Pod
metadata:
  name: nextcloud-postgres
  labels:
    app: nextcloud-postgres
spec:
  restartPolicy: Always
  containers:
    - name: db
      image: postgres:alpine
      env:
        - name: POSTGRES_PASSWORD
          value: "nextcloud"
        - name: POSTGRES_DB
          value: "nextcloud"
        - name: POSTGRES_USER
          value: "nextcloud"
      ports:
        - containerPort: 5432
      volumeMounts:
        - name: db-data
          mountPath: /var/lib/postgresql/data
    - name: nc
      image: nextcloud:apache
      env:
        - name: POSTGRES_HOST
          value: "db"
        - name: POSTGRES_PASSWORD
          value: "nextcloud"
        - name: POSTGRES_DB
          value: "nextcloud"
        - name: POSTGRES_USER
          value: "nextcloud"
      ports:
        - containerPort: 80
          hostPort: 80
      volumeMounts:
        - name: nc-data
          mountPath: /var/www/html
  volumes:
    - name: db-data
      emptyDir: {}
    - name: nc-data
      emptyDir: {}
```
Run:

```bash
cd nextcloud-postgres
podman kube play kube.yaml
podman kube down kube.yaml
```
---

## 3. `postgresql-pgadmin/kube.yaml`

```yaml path="/home/ophil/src/awesome-pods/postgresql-pgadmin/kube.yaml" start=1 end=46
apiVersion: v1
kind: Pod
metadata:
  name: postgresql-pgadmin
  labels:
    app: postgresql-pgadmin
spec:
  restartPolicy: Always
  containers:
    - name: postgres
      image: postgres:latest
      env:
        - name: POSTGRES_USER
          valueFrom:
            secretKeyRef:
              name: postgres-env
              key: POSTGRES_USER
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-env
              key: POSTGRES_PW
        - name: POSTGRES_DB
          valueFrom:
            secretKeyRef:
              name: postgres-env
              key: POSTGRES_DB
      ports:
        - containerPort: 5432
          hostPort: 5432
    - name: pgadmin
      image: dpage/pgadmin4:latest
      env:
        - name: PGADMIN_DEFAULT_EMAIL
          valueFrom:
            secretKeyRef:
              name: postgres-env
              key: PGADMIN_MAIL
        - name: PGADMIN_DEFAULT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-env
              key: PGADMIN_PW
      ports:
        - containerPort: 80
          hostPort: 5050
```
For podman, you’ll typically just export the same `.env` values as environment before `kube play`, or create a small Secret-equivalent manifest if you want full k8s parity. Minimal usage:

```bash
cd postgresql-pgadmin
# ensure env vars are set in your shell or adapt the manifest to hard-code them for local use
podman kube play kube.yaml
podman kube down kube.yaml
```
If you prefer not to model Secrets, you can replace the `valueFrom` blocks with literal `value:` entries.

---

## 4. `prometheus-grafana/kube.yaml`

```yaml path="/home/ophil/src/awesome-pods/prometheus-grafana/kube.yaml" start=1 end=43
apiVersion: v1
kind: Pod
metadata:
  name: prometheus-grafana
  labels:
    app: prometheus-grafana
spec:
  restartPolicy: Always
  containers:
    - name: prometheus
      image: prom/prometheus
      args:
        - '--config.file=/etc/prometheus/prometheus.yml'
      ports:
        - containerPort: 9090
          hostPort: 9090
      volumeMounts:
        - name: prom-config
          mountPath: /etc/prometheus
        - name: prom-data
          mountPath: /prometheus
    - name: grafana
      image: grafana/grafana
      env:
        - name: GF_SECURITY_ADMIN_USER
          value: 'admin'
        - name: GF_SECURITY_ADMIN_PASSWORD
          value: 'grafana'
      ports:
        - containerPort: 3000
          hostPort: 3000
      volumeMounts:
        - name: grafana-config
          mountPath: /etc/grafana/provisioning/datasources
  volumes:
    - name: prom-config
      hostPath:
        path: ./prometheus
    - name: prom-data
      emptyDir: {}
    - name: grafana-config
      hostPath:
        path: ./grafana
```
Run:

```bash
cd prometheus-grafana
podman kube play kube.yaml
podman kube down kube.yaml
```
---

## 5. `nginx-flask-mysql/kube.yaml`

```yaml path="/home/ophil/src/awesome-pods/nginx-flask-mysql/kube.yaml" start=1 end=42
apiVersion: v1
kind: Pod
metadata:
  name: nginx-flask-mysql
  labels:
    app: nginx-flask-mysql
spec:
  restartPolicy: Always
  containers:
    - name: db
      image: mariadb:10-focal
      args:
        - '--default-authentication-plugin=mysql_native_password'
      env:
        - name: MYSQL_DATABASE
          value: 'example'
        - name: MYSQL_ROOT_PASSWORD
          value: 'example'
      ports:
        - containerPort: 3306
      volumeMounts:
        - name: db-data
          mountPath: /var/lib/mysql
    - name: backend
      image: nginx-flask-backend
      ports:
        - containerPort: 8000
          hostPort: 8000
      livenessProbe:
        httpGet:
          path: /
          port: 8000
        initialDelaySeconds: 10
        periodSeconds: 30
    - name: proxy
      image: nginx-flask-proxy
      ports:
        - containerPort: 80
          hostPort: 80
  volumes:
    - name: db-data
      emptyDir: {}
```
Build & run:

```bash
cd nginx-flask-mysql
podman build -t nginx-flask-backend backend
podman build -t nginx-flask-proxy proxy
podman kube play kube.yaml
podman kube down kube.yaml
```
---

I’ve now covered:

- `aspnet-mssql`
- `django-postgres`, `rails-postgres`, `spring-postgres`, `sparkjava-mysql`
- `react-nginx`
- `elasticsearch-logstash-kibana`
- `nextcloud-postgres`
- `postgresql-pgadmin`
- `prometheus-grafana`
- `nginx-flask-mysql`

Next I can continue in the same mixed fashion with the remaining stacks: `nextcloud-redis-mariadb`, the other `nginx-*` variants, `react-*-*`, `pihole-cloudflared-DoH`, `wasmedge-*`, and `react-rust-postgres`.

USER:
yes, continue

AGENT:


**File Glob Results:**

- **/home/ophil/src/awesome-pods/aspnet-mssql/kube.yaml**
- **/home/ophil/src/awesome-pods/django-postgres/kube.yaml**
- **/home/ophil/src/awesome-pods/elasticsearch-logstash-kibana/kube.yaml**
- **/home/ophil/src/awesome-pods/nextcloud-postgres/kube.yaml**
- **/home/ophil/src/awesome-pods/nginx-flask-mysql/kube.yaml**
- **/home/ophil/src/awesome-pods/postgresql-pgadmin/kube.yaml**
- **/home/ophil/src/awesome-pods/prometheus-grafana/kube.yaml**
- **/home/ophil/src/awesome-pods/rails-postgres/kube.yaml**
- **/home/ophil/src/awesome-pods/react-nginx/kube.yaml**
- **/home/ophil/src/awesome-pods/sparkjava-mysql/kube.yaml**
- **/home/ophil/src/awesome-pods/spring-postgres/kube.yaml**
- **/home/ophil/src/awesome-pods/angular/compose.yaml**
- **/home/ophil/src/awesome-pods/angular/kube.yaml**
- **/home/ophil/src/awesome-pods/apache-php/compose.yaml**
- **/home/ophil/src/awesome-pods/apache-php/kube.yaml**
- **/home/ophil/src/awesome-pods/aspnet-mssql/compose.yaml**
- **/home/ophil/src/awesome-pods/django-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/django/compose.yaml**
- **/home/ophil/src/awesome-pods/django/kube.yaml**
- **/home/ophil/src/awesome-pods/elasticsearch-logstash-kibana/compose.yaml**
- **/home/ophil/src/awesome-pods/fastapi/compose.yaml**
- **/home/ophil/src/awesome-pods/fastapi/kube.yaml**
- **/home/ophil/src/awesome-pods/flask-redis/compose.yaml**
- **/home/ophil/src/awesome-pods/flask-redis/kube.yaml**
- **/home/ophil/src/awesome-pods/flask/compose.yaml**
- **/home/ophil/src/awesome-pods/flask/kube.yaml**
- **/home/ophil/src/awesome-pods/gitea-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/gitea-postgres/kube.yaml**
- **/home/ophil/src/awesome-pods/minecraft/compose.yaml**
- **/home/ophil/src/awesome-pods/minecraft/kube.yaml**
- **/home/ophil/src/awesome-pods/nextcloud-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/nextcloud-redis-mariadb/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-aspnet-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-flask-mongo/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-flask-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-golang-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-golang-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-golang/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-nodejs-redis/compose.yaml**
- **/home/ophil/src/awesome-pods/nginx-wsgi-flask/compose.yaml**
- **/home/ophil/src/awesome-pods/pihole-cloudflared-DoH/compose.yaml**
- **/home/ophil/src/awesome-pods/plex/compose.yaml**
- **/home/ophil/src/awesome-pods/plex/kube.yaml**
- **/home/ophil/src/awesome-pods/portainer/compose.yaml**
- **/home/ophil/src/awesome-pods/portainer/kube.yaml**
- **/home/ophil/src/awesome-pods/postgresql-pgadmin/compose.yaml**
- **/home/ophil/src/awesome-pods/prometheus-grafana/compose.yaml**
- **/home/ophil/src/awesome-pods/rails-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/react-express-mongodb/compose.yaml**
- **/home/ophil/src/awesome-pods/react-express-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/react-java-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/react-nginx/compose.yaml**
- **/home/ophil/src/awesome-pods/react-rust-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/sparkjava-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/sparkjava/compose.yaml**
- **/home/ophil/src/awesome-pods/sparkjava/kube.yaml**
- **/home/ophil/src/awesome-pods/spring-postgres/compose.yaml**
- **/home/ophil/src/awesome-pods/traefik-golang/compose.yaml**
- **/home/ophil/src/awesome-pods/traefik-golang/kube.yaml**
- **/home/ophil/src/awesome-pods/vuejs/compose.yaml**
- **/home/ophil/src/awesome-pods/vuejs/kube.yaml**
- **/home/ophil/src/awesome-pods/wasmedge-kafka-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/wasmedge-mysql-nginx/compose.yaml**
- **/home/ophil/src/awesome-pods/wireguard/compose.yaml**
- **/home/ophil/src/awesome-pods/wireguard/kube.yaml**
- **/home/ophil/src/awesome-pods/wordpress-mysql/compose.yaml**
- **/home/ophil/src/awesome-pods/wordpress-mysql/kube.yaml**



_Read files error: These files do not exist: /home/ophil/src/awesome-pods/react-rust-postgres/README.md _



**Files Read:**

**/home/ophil/src/awesome-pods/nextcloud-redis-mariadb/compose.yaml**
```
services:
  nc:
    image: nextcloud:apache
    restart: always
    ports:
      - 80:80
    volumes:
      - nc_data:/var/www/html
    networks:
      - redisnet
      - dbnet
    environment:
      - REDIS_HOST=redis
      - MYSQL_HOST=db
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_PASSWORD=nextcloud
  redis:
    image: redis:alpine
    restart: always
    networks:
      - redisnet
    expose:
      - 6379
  db:
    image: mariadb:10.5
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    restart: always
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - dbnet
    environment:
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_ROOT_PASSWORD=nextcloud
      - MYSQL_PASSWORD=nextcloud
    expose:
      - 3306
volumes:
  db_data:
  nc_data:
networks:
  dbnet:
  redisnet:

```

**/home/ophil/src/awesome-pods/nextcloud-redis-mariadb/README.md**
```
## Nextcloud with Redis and MariaDB
This example defines one of the basic setups for Nextcloud. More details on how to
further customize the installation and the compose file can be found on the
[official image page](https://hub.docker.com/_/nextcloud).


Project structure:
```
.
├── compose.yaml
└── README.md
```

[_compose.yaml_](compose.yaml)
```
services:
  nc:
    image: nextcloud:apache
    ports:
      - 80:80
    ...
  redis:
    image: redis:alpine
    restart: always
    networks:
      - redisnet
  db:
    image: mariadb
    ...
```

When deploying this setup, docker compose maps the nextcloud container port 80 to
port 80 of the host as specified in the compose file.

## Deploy with docker compose

```
$ docker compose up -d
Creating network "nextcloud-redis-mariadb_redisnet" with the default driver
Creating network "nextcloud-redis-mariadb_dbnet" with the default driver
Creating volume "nextcloud-redis-mariadb_nc_data" with default driver
Pulling redis (redis:alpine)...
alpine: Pulling from library/redis....
....
Status: Downloaded newer image for mariadb:latest
Creating nextcloud-redis-mariadb_db_1    ... done
Creating nextcloud-redis-mariadb_nc_1    ... done
Creating nextcloud-redis-mariadb_redis_1 ... done
```


## Expected result

Check containers are running and the port mapping:
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
6541add4d648        nextcloud:apache    "/entrypoint.sh apac…"   35 seconds ago      Up 34 seconds       0.0.0.0:80->80/tcp   nextcloud-redis-mariadb_nc_1
6c656f98cf14        redis:alpine        "docker-entrypoint.s…"   35 seconds ago      Up 34 seconds       6379/tcp             nextcloud-redis-mariadb_redis_1
6d4c6630a4a3        mariadb             "docker-entrypoint.s…"   35 seconds ago      Up 34 seconds       3306/tcp             nextcloud-redis-mariadb_db_1
```

Navigate to `http://localhost:80` in your web browser to access the installed
Nextcloud service.

![page](output.jpg)

Stop and remove the containers

```
$ docker compose down
```

To delete all data, remove all named volumes by passing the `-v` arguments:
```
$ docker compose down -v
```

```

**/home/ophil/src/awesome-pods/nginx-aspnet-mysql/compose.yaml**
```
services:
  backend:
    build:
      context: backend
    restart: always
    secrets:
      - db-password
    depends_on:
      db:
        condition: service_healthy
    environment:
      - ASPNETCORE_URLS=http://+:8000

  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8
    command: '--default-authentication-plugin=mysql_native_password'
    restart: always
    healthcheck:
      test: ['CMD-SHELL', 'mysqladmin ping -h 127.0.0.1 --password="$$(cat /run/secrets/db-password)" --silent']
      interval: 3s
      retries: 5
      start_period: 30s
    secrets:
      - db-password
    volumes:
      - db-data:/var/lib/mysql
    environment:
      - MYSQL_DATABASE=example
      - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db-password

  proxy:
    build: proxy
    ports:
      - 80:80
    depends_on: 
      - backend

volumes:
  db-data:

secrets:
  db-password:
    file: db/password.txt

```

**/home/ophil/src/awesome-pods/nginx-aspnet-mysql/README.md**
```
## Compose sample application
### ASP.NET server with a Nginx proxy and a MySQL database

Project structure:
```
.
├── backend
│   ├── Dockerfile
│   ├── aspnet.csproj
│   └── Program.cs
├── db
│   └── password.txt
├── compose.yaml
├── proxy
│   ├── conf
│   └── Dockerfile
└── README.md
```

[_compose.yaml_](compose.yaml)
```
services:
  backend:
    build:
      context: backend
    ...
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8
    ...
  proxy:
    build: proxy
    ports:
    - 80:80
    ...
```
The compose file defines an application with three services `proxy`, `backend` and `db`.
When deploying the application, docker compose maps port 80 of the proxy service container to port 80 of the host as specified in the file.
Make sure port 80 on the host is not already being in use.

> ℹ️ **_INFO_**  
> For compatibility purpose between `AMD64` and `ARM64` architecture, we use a MariaDB as database instead of MySQL.  
> You still can use the MySQL image by uncommenting the following line in the Compose file   
> `#image: mysql:8.0.27`

## Deploy with docker compose

```
$ docker compose up -d
```

## Expected result

Listing containers must show three containers running and the port mapping as below:
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
8906b14c5ad1        nginx-aspnet-mysql_proxy     "nginx -g 'daemon of…"   2 minutes ago       Up 2 minutes        0.0.0.0:80->80/tcp    nginx-aspnet-mysql
l_proxy_1
13e0e0a7715a        nginx-aspnet-mysql_backend   "/server"                2 minutes ago       Up 2 minutes        8000/tcp              nginx-aspnet-mysq
l_backend_1
ca8c5975d205        mysql:5.7                    "docker-entrypoint.s…"   2 minutes ago       Up 2 minutes        3306/tcp, 33060/tcp   nginx-aspnet-mysql
l_db_1
```

After the application starts, navigate to `http://localhost:80` in your web browser or run:
```
$ curl localhost:80
["Blog post #0","Blog post #1","Blog post #2","Blog post #3","Blog post #4"]
```

Stop and remove the containers
```
$ docker compose down
```

```

**/home/ophil/src/awesome-pods/nginx-flask-mongo/compose.yaml**
```
services:
  web:
    image: nginx
    volumes:
      - ./nginx/nginx.conf:/tmp/nginx.conf
    environment: 
      - FLASK_SERVER_ADDR=backend:9091  
    command: /bin/bash -c "envsubst < /tmp/nginx.conf > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'" 
    ports:
      - 80:80
    depends_on:
      - backend

  backend:
    build:
      context: flask
      target: builder
    # flask requires SIGINT to stop gracefully
    # (default stop signal from Compose is SIGTERM)
    stop_signal: SIGINT
    environment:
      - FLASK_SERVER_PORT=9091
    volumes:
      - ./flask:/src
    depends_on:
      -  mongo  

  mongo:
    image: mongo

```

**/home/ophil/src/awesome-pods/nginx-flask-mongo/README.md**
```
## Compose sample application
### Python/Flask application with Nginx proxy and a Mongo database

Project structure:
```
.
├── compose.yaml
├── flask
│   ├── Dockerfile
│   ├── requirements.txt
│   └── server.py
└── nginx
    └── nginx.conf

```

[_compose.yaml_](compose.yaml)
```
services:
  web:
    build: app
    ports:
    - 80:80
  backend:
    build: flask
    ...
  mongo:
    image: mongo
```
The compose file defines an application with three services `web`, `backend` and `db`.
When deploying the application, docker compose maps port 80 of the web service container to port 80 of the host as specified in the file.
Make sure port 80 on the host is not being used by another container, otherwise the port should be changed.

## Deploy with docker compose

```
$ docker compose up -d
Creating network "nginx-flask-mongo_default" with the default driver
Pulling mongo (mongo:)...
latest: Pulling from library/mongo
423ae2b273f4: Pull complete
...
...
Status: Downloaded newer image for nginx:latest
Creating nginx-flask-mongo_mongo_1 ... done
Creating nginx-flask-mongo_backend_1 ... done
Creating nginx-flask-mongo_web_1     ... done

```

## Expected result

Listing containers must show three containers running and the port mapping as below:
```
$ docker ps
CONTAINER ID        IMAGE                        COMMAND                  CREATED             STATUS              PORTS                  NAMES
a0f4ebe686ff        nginx                       "/bin/bash -c 'envsu…"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp     nginx-flask-mongo_web_1
dba87a080821        nginx-flask-mongo_backend   "./server.py"            About a minute ago   Up About a minute                          nginx-flask-mongo_backend_1
d7eea5481c77        mongo                       "docker-entrypoint.s…"   About a minute ago   Up About a minute   27017/tcp              nginx-flask-mongo_mongo_1
```

After the application starts, navigate to `http://localhost:80` in your web browser or run:
```
$ curl localhost:80
Hello from the MongoDB client!
```

Stop and remove the containers
```
$ docker compose down
```

```

**/home/ophil/src/awesome-pods/nginx-golang-mysql/compose.yaml**
```
services:
  backend:
    build:
      context: backend
      target: builder
    secrets:
      - db-password
    depends_on:
      db:
        condition: service_healthy

  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8
    command: '--default-authentication-plugin=mysql_native_password'
    restart: always
    healthcheck:
      test: ['CMD-SHELL', 'mysqladmin ping -h 127.0.0.1 --password="$$(cat /run/secrets/db-password)" --silent']
      interval: 3s
      retries: 5
      start_period: 30s
    secrets:
      - db-password
    volumes:
      - db-data:/var/lib/mysql
    environment:
      - MYSQL_DATABASE=example
      - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db-password
    expose:
      - 3306

  proxy:
    image: nginx
    volumes:
      - type: bind
        source: ./proxy/nginx.conf
        target: /etc/nginx/conf.d/default.conf
        read_only: true
    ports:
      - 80:80
    depends_on: 
      - backend

volumes:
  db-data:

secrets:
  db-password:
    file: db/password.txt

```

**/home/ophil/src/awesome-pods/nginx-golang-mysql/README.md**
```
## Compose sample application
### Go server with a Nginx proxy and a MariaDB/MySQL database

Project structure:
```
.
├── backend
│   ├── Dockerfile
│   ├── go.mod
│   ├── go.sum
│   └── main.go
├── db
│   └── password.txt
├── proxy
│   └── nginx.conf
├── compose.yaml
└── README.md
```

[_compose.yaml_](compose.yaml)
```yaml
services:
  backend:
    build:
      context: backend
      target: builder
    ...
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8
    ...
  proxy:
    image: nginx
    volumes:
      - type: bind
        source: ./proxy/nginx.conf
        target: /etc/nginx/conf.d/default.conf
        read_only: true
    ports:
    - 80:80
    ...
```
The compose file defines an application with three services `proxy`, `backend` and `db`.
When deploying the application, docker compose maps port 80 of the proxy service container to port 80 of the host as specified in the file.
Make sure port 80 on the host is not already being in use.

> ℹ️ **_INFO_**  
> For compatibility purpose between `AMD64` and `ARM64` architecture, we use a MariaDB as database instead of MySQL.  
> You still can use the MySQL image by uncommenting the following line in the Compose file   
> `#image: mysql:8`

## Deploy with docker compose

```shell
$ docker compose up -d
Creating network "nginx-golang-mysql_default" with the default driver
Building backend
Step 1/8 : FROM golang:1.13-alpine AS build
1.13-alpine: Pulling from library/golang
...
Successfully built 5f7c899f9b49
Successfully tagged nginx-golang-mysql_proxy:latest
WARNING: Image for service proxy was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating nginx-golang-mysql_db_1 ... done
Creating nginx-golang-mysql_backend_1 ... done
Creating nginx-golang-mysql_proxy_1   ... done
```

## Expected result

Listing containers must show three containers running and the port mapping as below:
```shell
$ docker compose ps
NAME                           COMMAND                  SERVICE             STATUS              PORTS
nginx-golang-mysql-backend-1   "/code/bin/backend"      backend             running
nginx-golang-mysql-db-1        "docker-entrypoint.s…"   db                  running (healthy)   3306/tcp
nginx-golang-mysql-proxy-1     "/docker-entrypoint.…"   proxy               running             0.0.0.0:80->80/tcp
l_db_1
```

After the application starts, navigate to `http://localhost:80` in your web browser or run:
```shell
$ curl localhost:80
["Blog post #0","Blog post #1","Blog post #2","Blog post #3","Blog post #4"]
```

Stop and remove the containers
```shell
$ docker compose down
```

```

**/home/ophil/src/awesome-pods/nginx-golang-postgres/compose.yaml**
```
services:
  backend:
    build:
      context: backend
      target: builder
    secrets:
      - db-password
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres
    restart: always
    user: postgres
    secrets:
      - db-password
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=example
      - POSTGRES_PASSWORD_FILE=/run/secrets/db-password
    expose:
      - 5432
    healthcheck:
      test: [ "CMD", "pg_isready" ]
      interval: 10s
      timeout: 5s
      retries: 5

  proxy:
    image: nginx
    volumes:
      - type: bind
        source: ./proxy/nginx.conf
        target: /etc/nginx/conf.d/default.conf
        read_only: true
    ports:
      - 80:80
    depends_on: 
      - backend

volumes:
  db-data:

secrets:
  db-password:
    file: db/password.txt

```

**/home/ophil/src/awesome-pods/nginx-golang-postgres/README.md**
```
## Compose sample application
### Go server with a Nginx proxy and a Postgres database

Project structure:
```
.
├── backend
│   ├── Dockerfile
│   ├── go.mod
│   ├── go.sum
│   └── main.go
├── db
│   └── password.txt
├── compose.yaml
├── proxy
│   └── nginx.conf
└── README.md
```

[_compose.yaml_](compose.yaml)
```shell
services:
  backend:
    build:
      context: backend
      target: builder
    ...
  db:
    image: postgres
    ...
  proxy:
    image: nginx
    volumes:
      - type: bind
        source: ./proxy/nginx.conf
        target: /etc/nginx/conf.d/default.conf
        read_only: true
    ports:
      - 80:80
    ...
```
The compose file defines an application with three services `proxy`, `backend` and `db`.
When deploying the application, docker compose maps port 80 of the proxy service container to port 80 of the host as specified in the file.
Make sure port 80 on the host is not already being in use.

## Deploy with docker compose

```shell
$ docker compose up -d
Creating network "nginx-golang-postgres_default" with the default driver
Pulling db (postgres:)...
latest: Pulling from library/postgres
...
Successfully built 5f7c899f9b49
Successfully tagged nginx-golang-postgres_proxy:latest
WARNING: Image for service proxy was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating nginx-golang-postgres_db_1 ... done
Creating nginx-golang-postgres_backend_1 ... done
Creating nginx-golang-postgres_proxy_1   ... done
```

## Expected result

Listing containers must show three containers running and the port mapping as below:
```shell
$ docker compose ps
NAME                              COMMAND                  SERVICE             STATUS              PORTS
nginx-golang-postgres-backend-1   "/code/bin/backend"      backend             running
nginx-golang-postgres-db-1        "docker-entrypoint.s…"   db                  running (healthy)   5432/tcp
nginx-golang-postgres-proxy-1     "/docker-entrypoint.…"   proxy               running             0.0.0.0:80->80/tcp
```

After the application starts, navigate to `http://localhost:80` in your web browser or run:
```shell
$ curl localhost:80
["Blog post #0","Blog post #1","Blog post #2","Blog post #3","Blog post #4"]
```

Stop and remove the containers
```shell
$ docker compose down
```

```

**/home/ophil/src/awesome-pods/nginx-golang/compose.yaml**
```
services:
  proxy:
    image: nginx
    volumes:
      - type: bind
        source: ./proxy/nginx.conf
        target: /etc/nginx/conf.d/default.conf
        read_only: true
    ports:
      - 80:80
    depends_on:
      - backend

  backend:
    build:
      context: backend
      target: builder

```

**/home/ophil/src/awesome-pods/nginx-golang/README.md**
```
## Compose sample application
### NGINX proxy with Go backend

Project structure:
```
.
├── backend
│   ├── Dockerfile
│   └── main.go
├── compose.yaml
├── proxy
│   └── nginx.conf
└── README.md
```

[`compose.yaml`](compose.yaml)
```
services:
  proxy:
    image: nginx
    volumes:
      - type: bind
        source: ./proxy/nginx.conf
        target: /etc/nginx/conf.d/default.conf
        read_only: true
    ports:
      - 80:80
    depends_on:
      - backend

  backend:
    build:
      context: backend
      target: builder
```
The compose file defines an application with two services `proxy` and `backend`.
When deploying the application, docker compose maps port 80 of the frontend service container to the same port of the host as specified in the file.
Make sure port 80 on the host is not already in use.

## Deploy with docker compose

```
$ docker compose up -d
Creating network "nginx-golang_default" with the default driver
Building backend
Step 1/7 : FROM golang:1.13 AS build
1.13: Pulling from library/golang
...
Successfully built 4b24f27138cc
Successfully tagged nginx-golang_proxy:latest
Creating nginx-golang_backend_1 ... done
Creating nginx-golang_proxy_1 ... done
```

## Expected result

Listing containers must show two containers running and the port mapping as below:
```
$ docker compose ps
NAME                     COMMAND                  SERVICE             STATUS              PORTS
nginx-golang-backend-1   "/code/bin/backend"      backend             running
nginx-golang-proxy-1     "/docker-entrypoint.…"   proxy               running             0.0.0.0:80->80/tcp
```

After the application starts, navigate to `http://localhost:80` in your web browser or run:
```
$ curl localhost:80

          ##         .
    ## ## ##        ==
 ## ## ## ## ##    ===
/"""""""""""""""""\___/ ===
{                       /  ===-
\______ O           __/
 \    \         __/
  \____\_______/

	
Hello from Docker!
```

Stop and remove the containers
```
$ docker compose down
```

```

**/home/ophil/src/awesome-pods/nginx-nodejs-redis/compose.yaml**
```

services:
  redis:
    image: 'redislabs/redismod'
    ports:
      - '6379:6379'
  web1:
    restart: on-failure
    build: ./web
    hostname: web1
    ports:
      - '81:5000'
  web2:
    restart: on-failure
    build: ./web
    hostname: web2
    ports:
      - '82:5000'
  nginx:
    build: ./nginx
    ports:
    - '80:80'
    depends_on:
    - web1
    - web2



```

**/home/ophil/src/awesome-pods/nginx-nodejs-redis/README.md**
```
## Compose sample application

## Node.js application with Nginx proxy and Redis database

Project structure:
```
.
├── README.md
├── compose.yaml
├── nginx
│   ├── Dockerfile
│   └── nginx.conf
└── web
    ├── Dockerfile
    ├── package.json
    └── server.js

2 directories, 7 files


```
[_compose.yaml_](compose.yaml)
```
redis:
    image: 'redislabs/redismod'
    ports:
      - '6379:6379'
  web1:
    restart: on-failure
    build: ./web
    hostname: web1
    ports:
      - '81:5000'
  web2:
    restart: on-failure
    build: ./web
    hostname: web2
    ports:
      - '82:5000'
  nginx:
    build: ./nginx
    ports:
    - '80:80'
    depends_on:
    - web1
    - web2
```
The compose file defines an application with four services `redis`, `nginx`, `web1` and `web2`.
When deploying the application, docker compose maps port 80 of the nginx service container to port 80 of the host as specified in the file.


> ℹ️ **_INFO_**  
> Redis runs on port 6379 by default. Make sure port 6379 on the host is not being used by another container, otherwise the port should be changed.

## Deploy with docker compose

```
$ docker compose up -d
[+] Running 24/24
 ⠿ redis Pulled                                                                                                                                                                                                                      ...
   ⠿ 565225d89260 Pull complete                                                                                                                                                                                                      
[+] Building 2.4s (22/25)
 => [nginx-nodejs-redis_nginx internal] load build definition from Dockerfile                                                                                                                                                         ...
[+] Running 5/5
 ⠿ Network nginx-nodejs-redis_default    Created                                                                                                                                                                                      
 ⠿ Container nginx-nodejs-redis-web2-1   Started                                                                                                                                                                                      
 ⠿ Container nginx-nodejs-redis-redis-1  Started                                                                                                                                                                                      
 ⠿ Container nginx-nodejs-redis-web1-1   Started                                                                                                                                                                                      
 ⠿ Container nginx-nodejs-redis-nginx-1  Started
```


## Expected result

Listing containers must show three containers running and the port mapping as below:


```
docker-compose ps
```

## Testing the app

After the application starts, navigate to `http://localhost:80` in your web browser or run:

```
curl localhost:80
curl localhost:80
web1: Total number of visits is: 1
```

```
curl localhost:80
web1: Total number of visits is: 2
```
```
$ curl localhost:80
web2: Total number of visits is: 3
```



## Stop and remove the containers

```
$ docker compose down
```


```

**/home/ophil/src/awesome-pods/nginx-wsgi-flask/compose.yaml**
```
services:
  nginx-proxy:
    build: nginx
    restart: always
    volumes:
      - ./nginx/default.conf:/tmp/default.conf
    environment: 
      - FLASK_SERVER_ADDR=flask-app:8000
    ports:
      - "80:80"
    depends_on:
      - flask-app
    healthcheck:
      test: ["CMD-SHELL", "curl --silent --fail localhost:80/health-check || exit 1"]
      interval: 10s
      timeout: 10s
      retries: 3
    command: /app/start.sh
  flask-app:
    build: flask
    restart: always
    ports: 
      - '8000:8000'
    healthcheck:
      test: ["CMD-SHELL", "curl --silent --fail localhost:8000/flask-health-check || exit 1"]
      interval: 10s
      timeout: 10s
      retries: 3
    command: gunicorn -w 3 -t 60 -b 0.0.0.0:8000 app:app

```

**/home/ophil/src/awesome-pods/nginx-wsgi-flask/README.md**
```
# Compose Sample Application

## NGINX Reverse Proxy -> WSGI -> Python/Flask Backend

Project structure:

```text
.
├── compose.yaml
├── flask
│   ├── app.py
│   ├── Dockerfile
│   ├── requirements.txt
│   └── wsgi.py
└── nginx
    ├── default.conf
    ├── Dockerfile
    ├── nginx.conf
    └── start.sh
```

[_compose.yaml_](compose.yaml)

```yml
services:
  nginx-proxy:
    build: nginx
    ports:
    - 80:80
  flask-app:
    build: flask
    ...
```

The compose file defines an application with two services `nginx-proxy` and `flask-app`.
When deploying the application, docker compose maps port 80 of the web service container to port 80 of the host as specified in the file.

Make sure port 80 on the host is not being used by another container, otherwise the port should be changed.

## Deploy with docker compose

```bash
$ docker compose up -d
Creating network "nginx-wsgi-flask_default" with the default driver
Building flask-app
...
Building nginx-proxy
...
Creating nginx-wsgi-flask_flask-app_1 ... done
Creating nginx-wsgi-flask_nginx-proxy_1 ... done
```

## Expected result

Listing containers must show two containers running and the port mapping as below:

```bash
$ docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED              STATUS                        PORTS                              NAMES
bde3f29cf571   ...nginx-proxy   "/docker-entrypoint.…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:80->80/tcp                 ...nginx-proxy_1
86c44470b547   ...flask-app     "gunicorn -w 3 -t 60…"   About a minute ago   Up About a minute (healthy)   5000/tcp, 0.0.0.0:8000->8000/tcp   ...flask-app_1
```

After the application starts, navigate to `http://localhost:80` in your web browser or run:

```bash
$ curl localhost:80
Hello World!
```

Stop and remove the containers

```bash
$ docker compose down
Stopping nginx-wsgi-flask_nginx-proxy_1 ... done
Stopping nginx-wsgi-flask_flask-app_1   ... done
Removing nginx-wsgi-flask_nginx-proxy_1 ... done
Removing nginx-wsgi-flask_flask-app_1   ... done
Removing network nginx-wsgi-flask_default
```

## About

By following the steps above, you will have an NGINX Reverse Proxy and a Flask backend. The general traffic flow will look like the following:

`Client -> NGINX -> WSGI -> Flask`

### NGINX

With this deployment model, we use NGINX to proxy and handle all requests to our Flask backend. This is a powerful deployment model as we can use NGINX to cache responses or even act as an application load balancer between multiple Flask backends. You could also integrate a Web Application Firewall into NGINX to protect your Flask backend from attacks.

### WSGI

WSGI (Web Server Gateway Interface) is the interface that sits in between our NGINX proxy and Flask backend. It is used to handle requests and interface with our backend. WSGI allows you to handle thousands of requests at a time and is highly scalable. In this `docker-compose` sample, we use Gunicorn for our WSGI.

### Flask

Flask is a web development framework written in Python. It is the "backend" which processes requests.

A couple of sample endpoints are provided in this `docker-compose` example:

* `/` - Returns a "Hello World!" string.
* `/cache-me` - Returns a string which is cached by the NGINX reverse proxy. This demonstrates an intermediary cache implementation.
* `/info` - Returns informational headers about the request. Some are passed from NGINX for added client visibility.

```

**/home/ophil/src/awesome-pods/pihole-cloudflared-DoH/compose.yaml**
```
version: '3.7'
services:
  cloudflared:
    image: visibilityspots/cloudflared
    container_name: cloudflared
    ports:
      - "5054:5054/tcp"
      - "5054:5054/udp"
    environment:
      - TZ=${TIMEZONE}
      - PORT=5054
      - ADDRESS=0.0.0.0
    restart: always
    networks:
      dns-net:
        ipv4_address: 172.20.0.2

  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "8080:80/tcp"
      - "8443:443/tcp"
    environment:
      - TZ=${TIMEZONE}
      - PIHOLE_DNS_=172.20.0.2#5054;1.1.1.1 # referencing by name results in "Invalid IP detected in PIHOLE_DNS_: cloudflared#5054"
      - WEBPASSWORD=${PIHOLE_PW}
      - REV_SERVER=true
      - REV_SERVER_TARGET=${PIHOLE_ROUTER_IP}
      - REV_SERVER_DOMAIN=${PIHOLE_NETWORK_DOMAIN}
      - REV_SERVER_CIDR=${PIHOLE_REVERSE_DNS}
      - ServerIP=${PIHOLE_HOST_IP}
      - ServerIPv6=${PIHOLE_HOST_IPV6}
    #dns:
      #- 127.0.0.1 # "Sets your container's resolve settings to localhost so it can resolve DHCP hostnames [...]" - github.com/pi-hole/docker-pi-hole
      #- 1.1.1.1 # Backup server
    volumes: # store your data between container upgrades
      - "/etc/pihole/:/etc/pihole/"
      - "/etc/dnsmasq.d/:/etc/dnsmasq.d/"
    cap_add:
      - NET_ADMIN # Recommended but not required (DHCP needs NET_ADMIN) https://github.com/pi-hole/docker-pi-hole#note-on-capabilities
    depends_on:
      - "cloudflared"
    restart: always
    networks:
      - dns-net

networks:
  dns-net:
    ipam:
      config:
        - subnet: 172.20.0.0/24
```

**/home/ophil/src/awesome-pods/pihole-cloudflared-DoH/README.md**
```
## Pi-hole with cloudflared DoH (DNS-Over-HTTPS)
This example provides a base setup for using [Pi-hole](https://docs.pi-hole.net/) with the [cloudflared DoH](https://docs.pi-hole.net/guides/dns/cloudflared/) service.
More details on how to customize the installation and the compose file can be found in [Docker Pi-hole documentation](https://github.com/pi-hole/docker-pi-hole).


Project structure:
```
.
├── .env
├── compose.yaml
└── README.md
```

[_compose.yaml_](compose.yaml)
``` yaml
services:
  pihole:
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "8080:80/tcp"
      - "8443:443/tcp"
    ...
  cloudflared:
    image: visibilityspots/cloudflared
    ports:
      - "5054:5054/tcp"
      - "5054:5054/udp"
    ...
```

## Configuration

### .env
Before deploying this setup, you need to configure the following values in the [.env](.env) file.
- TZ ([time zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones))
- PIHOLE_PW (admin password)
- PIHOLE_ROUTER_IP (only needed for activated conditional forwarding)
- PIHOLE_NETWORK_DOMAIN (only needed for activated conditional forwarding)
- PIHOLE_HOST_IP (IPv4 address of your Pi-hole - needs to be static)
- PIHOLE_HOST_IPV6 (IPv6 address of your Pi-hole - can be empty if you only use IPv4)

### Conditional forwarding (optional, default: enabled)
If you would like to disable conditional forwarding, delete the environment variables starting with "CONDITIONAL_FORWARDING"

### Container DNS (optional, default: disabled)
In the docker compose file, dns is added as a comment. To enable dns remove '#' in front of the following lines: 
``` yaml
dns:
    - 127.0.0.1 # "Sets your container's resolve settings to localhost so it can resolve DHCP hostnames [...]" - github.com/pi-hole/docker-pi-hole
    - 1.1.1.1 # Backup server 
```

## Deploy with docker compose
When deploying this setup, the admin web interface will be available on port 8080 (e.g. http://localhost:8080/admin).

``` shell
$ docker compose up -d
Starting cloudflared ... done
Starting pihole      ... done
```


## Expected result

Check containers are running and the port mapping:
```
$ docker ps
CONTAINER ID   IMAGE                                 COMMAND                  CREATED         STATUS                            PORTS                                                                                                     NAMES
afcf5ca4214c   pihole/pihole:latest                  "/s6-init"               3 seconds ago   Up 3 seconds (health: starting)   0.0.0.0:53->53/udp, 0.0.0.0:53->53/tcp, 0.0.0.0:67->67/udp, 0.0.0.0:8080->80/tcp, 0.0.0.0:8443->443/tcp   pihole
dfd49ab7a372   visibilityspots/cloudflared           "/bin/sh -c '/usr/lo…"   4 seconds ago   Up 3 seconds (health: starting)   0.0.0.0:5054->5054/tcp, 0.0.0.0:5054->5054/udp                                                            cloudflared
```

Navigate to `http://localhost:8080` in your web browser to access the installed Pi-hole web interface.


Stop the containers with
``` shell
$ docker compose down
# To delete all data run:
$ docker compose down -v
```

## Troubleshooting

### - Starting / Stopping pihole-FTL loop:
  Sometimes, it can happen that there occurs a problem starting pihole-FTL.
  I personally had this issue when adding this line to the shared volumes:
  ```
  - "/pihole/pihole.log:/var/log/pihole.log"
  ```
  To fix this issue, I found this [issue](https://github.com/pi-hole/docker-pi-hole/issues/645#issuecomment-670809672), 
  which suggested adding an empty file (`touch /pihole/pihole.log`) to prevent it from creating a directory.
  The directory would not allow starting pihole-FTL and result in something like this:
  ```
  # Starting pihole-FTL (no-daemon) as root
  # Stopping pihole-FTL
  ...
  ```
  If you created an empty file, you may also check the ownership to prevent permission problems.
  
### - Installing on Ubuntu may conflict with `systemd-resolved` - see [Installing on Ubuntu](https://github.com/pi-hole/docker-pi-hole#installing-on-ubuntu-or-fedora) for help.

### - Environment variables are version-dependent
  Environment variables like "CONDIIONAL_FORWARDING*" and "DNS1" are deprecated and replaced by e.g. "REV_SERVER*" and "PIHOLE_DNS" in version 5.8+.
  Current information about environment variables can be found here: https://github.com/pi-hole/docker-pi-hole
```

**/home/ophil/src/awesome-pods/react-express-mongodb/README.md**
```
## Compose sample application
### React application with a NodeJS backend and a MongoDB database

Project structure:
```
.
├── backend
│   ├── Dockerfile
│   ...
├── compose.yaml
├── frontend
│   ├── ...
│   └── Dockerfile
└── README.md
```

[_compose.yaml_](compose.yaml)
```
services:
  frontend:
    build:
      context: frontend
    ...
    ports:
      - 3000:3000
    ...
  server:
    container_name: server
    restart: always
    build:
      context: server
      args:
        NODE_PORT: 3000
    ports:
      - 3000:3000
    ...
    depends_on:
      - mongo
  mongo:
    container_name: mongo
    restart: always
    ...
```
The compose file defines an application with three services `frontend`, `backend` and `db`.
When deploying the application, docker compose maps port 3000 of the frontend service container to port 3000 of the host as specified in the file.
Make sure port 3000 on the host is not already being in use.

## Deploy with docker compose

```
$ docker compose up -d
Creating network "react-express-mongodb_default" with the default driver
Building frontend
Step 1/9 : FROM node:13.13.0-stretch-slim
 ---> aa6432763c11
...
Successfully tagged react-express-mongodb_app:latest
WARNING: Image for service app was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating frontend        ... done
Creating mongo           ... done
Creating app             ... done
```

## Expected result

Listing containers must show containers running and the port mapping as below:
```
$ docker ps
CONTAINER ID        IMAGE                               COMMAND                  CREATED             STATUS                  PORTS                      NAMES
06e606d69a0e        react-express-mongodb_server        "docker-entrypoint.s…"   23 minutes ago      Up 23 minutes           0.0.0.0:3000->3000/tcp     server
ff56585e1db4        react-express-mongodb_frontend      "docker-entrypoint.s…"   23 minutes ago      Up 23 minutes           0.0.0.0:3000->3000/tcp     frontend
a1f321f06490        mongo:4.2.0                         "docker-entrypoint.s…"   23 minutes ago      Up 23 minutes           0.0.0.0:27017->27017/tcp   mongo
```

After the application starts, navigate to `http://localhost:3000` in your web browser.

![page](./output.png)

Stop and remove the containers
```
$ docker compose down
Stopping server   ... done
Stopping frontend ... done
Stopping mongo    ... done
Removing server   ... done
Removing frontend ... done
Removing mongo    ... done
```

##### Explanation of `docker-compose`

__Version__

The first line defines the version of a file. It sounds confusing :confused:. What is meant by version of file ?? 

:pill: The Compose file is a YAML file defining services, networks, and volumes for a Docker application. So it is only a version of describing compose.yaml file. There are several versions of the Compose file format – 1, 2, 2.x, and 3.x.

__Services__

Our main goal to create a containers, it starts from here. As you can see there are three services(Docker images): 
- First is __frontend__ 
- Second is __server__ which is __backend - Express(NodeJS)__. I used a name server here, it's totally on you to name it __backend__.
- Third is __mongo__ which is db __MongoDB__.

##### Service app (backend - NodeJS)

We make image of app from our `Dockerfile`, explanation below.

__Explanation of service server__

- Defining a **nodejs** service as __server__.
- We named our **node server** container service as **server**. Assigning a name to the containers makes it easier to read when there are lot of containers on a machine, it can also avoid randomly generated container names. (Although in this case, __container_name__ is also __server__, this is merely personal preference, the name of the service and container do not have to be the same.) 
- Docker container starts automatically if its fails.
- Building the __server__ image using the Dockerfile from the current directory and passing an argument to the
backend(server) `DockerFile`.
- Mapping the host port to the container port.

##### Service mongo

We add another service called **mongo** but this time instead of building it from `DockerFile` we write all the instruction here directly. We simply pull down the standard __mongo image__ from the [DockerHub](https://hub.docker.com/) registry as we have done it for Node image.

__Explanation of service mongo__

- Defining a **mongodb** service as __mongo__.
- Pulling the mongo 4.2.0 image image again from [DockerHub](https://hub.docker.com/).
- Mount our current db directory to container. 
- For persistent storage, we mount the host directory ( just like I did it in **Node** image inside `DockerFile` to reflect the changes) `/data` ( you need to create a directory in root of your project in order to save changes to locally as well) to the container directory `/data/db`, which was identified as a potential mount point in the `mongo Dockerfile` we saw earlier.
- Mounting volumes gives us persistent storage so when starting a new container, Docker Compose will use the volume of any previous containers and copy it to the new container, ensuring that no data is lost.
- Finally, we link/depends_on the app container to the mongo container so that the mongo service is reachable from the app service.
- In last mapping the host port to the container port.

:key: `If you wish to check your DB changes on your local machine as well. You should have installed MongoDB locally, otherwise you can't access your mongodb service of container from host machine.` 

:white_check_mark: You should check your __mongo__ version is same as used in image. You can see the version of __mongo__ image in `docker-compose `file, I used __image: mongo:4.2.0__. If your mongo db version on your machine is not same then furst you have to updated your  local __mongo__ version in order to works correctly.

```

**/home/ophil/src/awesome-pods/react-express-mysql/README.md**
```
## Compose sample application
### React application with a NodeJS backend and a MySQL database

Project structure:
```
.
├── backend
│   ├── Dockerfile
│   ...
├── db
│   └── password.txt
├── compose.yaml
├── frontend
│   ├── ...
│   └── Dockerfile
└── README.md
```

[_compose.yaml_](compose.yaml)
```
services:
  backend:
    build: backend
    ports:
      - 80:80
      - 9229:9229
      - 9230:9230
    ...
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10.6.4-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8.0.27
    ...
  frontend:
    build: frontend
    ports:
    - 3000:3000
    ...
```
The compose file defines an application with three services `frontend`, `backend` and `db`.
When deploying the application, docker compose maps port 3000 of the frontend service container to port 3000 of the host as specified in the file.
Make sure port 3000 on the host is not already being in use.

> ℹ️ **_INFO_**  
> For compatibility purpose between `AMD64` and `ARM64` architecture, we use a MariaDB as database instead of MySQL.  
> You still can use the MySQL image by uncommenting the following line in the Compose file   
> `#image: mysql:8.0.27`

## Deploy with docker compose

```
$ docker compose up -d
Creating network "react-express-mysql_default" with the default driver
Building backend
Step 1/16 : FROM node:10
 ---> aa6432763c11
...
Successfully tagged react-express-mysql_frontend:latest
WARNING: Image for service frontend was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating react-express-mysql_db_1 ... done
Creating react-express-mysql_backend_1 ... done
Creating react-express-mysql_frontend_1 ... done
```

## Expected result

Listing containers must show containers running and the port mapping as below:
```
$ docker ps
CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS                   PORTS                                                  NAMES
f3e1183e709e        react-express-mysql_frontend   "docker-entrypoint.s…"   8 minutes ago       Up 8 minutes             0.0.0.0:3000->3000/tcp                                 react-express-mysql_frontend_1
9422da53da76        react-express-mysql_backend    "docker-entrypoint.s…"   8 minutes ago       Up 8 minutes (healthy)   0.0.0.0:80->80/tcp, 0.0.0.0:9229-9230->9229-9230/tcp   react-express-mysql_backend_1
a434bce6d2be        mysql:8.0.19                   "docker-entrypoint.s…"   8 minutes ago       Up 8 minutes             3306/tcp, 33060/tcp                                    react-express-mysql_db_1
```

After the application starts, navigate to `http://localhost:3000` in your web browser.

![page](./output.png)


The backend service container has the port 80 mapped to 80 on the host.
```
$ curl localhost:80
{"message":"Hello from MySQL 8.0.19"}
```

Stop and remove the containers
```
$ docker compose down
Stopping react-express-mysql_frontend_1 ... done
Stopping react-express-mysql_backend_1  ... done
Stopping react-express-mysql_db_1       ... done
Removing react-express-mysql_frontend_1 ... done
Removing react-express-mysql_backend_1  ... done
Removing react-express-mysql_db_1       ... done
Removing network react-express-mysql_default

```

```

**/home/ophil/src/awesome-pods/react-java-mysql/README.md**
```
## Compose sample application
### React application with a Spring backend and a MySQL database

Project structure:
```
.
├── backend
│   ├── Dockerfile
│   ...
├── db
│   └── password.txt
├── compose.yaml
├── frontend
│   ├── ...
│   └── Dockerfile
└── README.md
```

[_compose.yaml_](compose.yaml)
```
services:
  backend:
    build: backend
    ...
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10.6.4-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8.0.27
    ...
  frontend:
    build: frontend
    ports:
    - 3000:3000
    ...
```
The compose file defines an application with three services `frontend`, `backend` and `db`.
When deploying the application, docker compose maps port 3000 of the frontend service container to port 3000 of the host as specified in the file.
Make sure port 3000 on the host is not already being in use.

> ℹ️ **_INFO_**
> For compatibility purpose between `AMD64` and `ARM64` architecture, we use a MariaDB as database instead of MySQL.
> You still can use the MySQL image by uncommenting the following line in the Compose file
> `#image: mysql:8.0.27`

## Deploy with docker compose

```
$ docker compose up -d
Creating network "react-java-mysql-default" with the default driver
Building backend
Step 1/17 : FROM maven:3.6.3-jdk-11 AS builder
...
Successfully tagged react-java-mysql_frontend:latest
WARNING: Image for service frontend was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating react-java-mysql-frontend-1 ... done
Creating react-java-mysql-db-1       ... done
Creating react-java-mysql-backend-1  ... done
```

## Expected result

Listing containers must show three containers running and the port mapping as below:
```
$ docker ps
ONTAINER ID        IMAGE                       COMMAND                  CREATED             STATUS              PORTS                  NAMES
a63dee74d79e        react-java-mysql-backend    "java -Djava.securit…"   39 seconds ago      Up 37 seconds                              react-java-mysql_backend-1
6a7364c0812e        react-java-mysql-frontend   "docker-entrypoint.s…"   39 seconds ago      Up 33 seconds       0.0.0.0:3000->3000/tcp react-java-mysql_frontend-1
b176b18fbec4        mysql:8.0.19                "docker-entrypoint.s…"   39 seconds ago      Up 37 seconds       3306/tcp, 33060/tcp    react-java-mysql_db-1
```

After the application starts, navigate to `http://localhost:3000` in your web browser to get a colorful message.
![page](./output.jpg)

Stop and remove the containers
```
$ docker compose down
Stopping react-java-mysql-backend-1  ... done
Stopping react-java-mysql-frontend-1 ... done
Stopping react-java-mysql-db-1       ... done
Removing react-java-mysql-backend-1  ... done
Removing react-java-mysql-frontend-1 ... done
Removing react-java-mysql-db-1       ... done
Removing network react-java-mysql-default
```

```

**/home/ophil/src/awesome-pods/wasmedge-kafka-mysql/compose.yaml**
```
services:
  redpanda:
    image: docker.redpanda.com/vectorized/redpanda:v22.2.2
    command:
      - redpanda start
      - --smp 1
      - --overprovisioned
      - --node-id 0
      - --kafka-addr PLAINTEXT://0.0.0.0:29092,OUTSIDE://0.0.0.0:9092
      - --advertise-kafka-addr PLAINTEXT://redpanda:29092,OUTSIDE://redpanda:9092
      - --pandaproxy-addr 0.0.0.0:8082
      - --advertise-pandaproxy-addr localhost:8082
    ports:
      - 8081:8081
      - 8082:8082
      - 9092:9092
      - 9644:9644
      - 29092:29092
    volumes:
      - ./kafka:/app
  etl:
    image: etl-kafka
    platform: wasi/wasm
    build:
      context: etl
    environment:
      DATABASE_URL: mysql://root:whalehello@db:3306/mysql
      KAFKA_URL: kafka://redpanda:9092/order
      RUST_BACKTRACE: full
      RUST_LOG: info
    restart: unless-stopped
    runtime: io.containerd.wasmedge.v1
  db:
    image: mariadb:10.9
    environment:
      MYSQL_ROOT_PASSWORD: whalehello

```

**/home/ophil/src/awesome-pods/wasmedge-kafka-mysql/README.md**
```
# Compose sample application

![Compatible with Docker+Wasm](../icon_wasm.svg)

This sample demonstrates a WebAssembly (Wasm) microservice written in Rust. It subscribes to a Kafka queue topic on a Redpanda server, and then transforms and saves each message into a MySQL (MariaDB) database table. The microservice is compiled into Wasm and runs in the WasmEdge runtime, which is a secure and lightweight alternative to natively compiled Rust apps in Linux containers.

## WasmEdge server with Redpanda and MySQL database

Project structure:

```
.
+-- compose.yml
|-- etl
    |-- Dockerfile
    |-- Cargo.toml
    +-- src
        |-- main.rs
|-- kafka
    |-- order.json
|-- db
    |-- db-password.txt
```

The [compose.yml](compose.yml) is as follows.

```yaml
services:
  redpanda:
    image: docker.redpanda.com/vectorized/redpanda:v22.2.2
    command:
      - redpanda start
      - --smp 1
      - --overprovisioned
      - --node-id 0
      - --kafka-addr PLAINTEXT://0.0.0.0:29092,OUTSIDE://0.0.0.0:9092
      - --advertise-kafka-addr PLAINTEXT://redpanda:29092,OUTSIDE://redpanda:9092
      - --pandaproxy-addr 0.0.0.0:8082
      - --advertise-pandaproxy-addr localhost:8082
    ports:
      - 8081:8081
      - 8082:8082
      - 9092:9092
      - 9644:9644
      - 29092:29092
    volumes:
      - ./kafka:/app

  etl:
    image: etl-kafka
    build:
      context: etl
      platforms:
        - wasi/wasm32
    environment:
      DATABASE_URL: mysql://root:whalehello@db:3306/mysql
      KAFKA_URL: kafka://redpanda:9092/order
      RUST_BACKTRACE: full
      RUST_LOG: info
    restart: unless-stopped
    runtime: io.containerd.wasmedge.v1

  db:
    image: mariadb:10.9
    environment:
      MYSQL_ROOT_PASSWORD: whalehello
```

The compose file defines an application with three services `redpanda`, `etl` and `db`. The `redpanda` service is a Kafka-compatible messaging server that produces messages in a queue topic. The `etl` service, in the WasmEdge container that subscribes to the queue topic and receives incoming messages. Each incoming message is parsed and stored in the `db` MySQL (MariaDB) database server.

## Deploy with docker compose

```bash
$ docker compose up -d
...
 ⠿ Network wasmedge-kafka-mysql_default       Created                      0.1s
 ⠿ Container wasmedge-kafka-mysql-redpanda-1  Created                      0.3s
 ⠿ Container wasmedge-kafka-mysql-etl-1       Created                      0.3s
 ⠿ Container wasmedge-kafka-mysql-db-1        Created                      0.3s
```

## Expected result

```bash
$ docker compose ps
NAME                              COMMAND                  SERVICE             STATUS              PORTS
wasmedge-kafka-mysql-db-1         "docker-entrypoint.s…"   db                  running             3306/tcp
wasmedge-kafka-mysql-etl-1        "kafka.wasm"             etl                 running
wasmedge-kafka-mysql-redpanda-1   "/entrypoint.sh 'red…"   redpanda            running             0.0.0.0:8081-8082->8081-8082/tcp, :::8081-8082->8081-8082/tcp, 0.0.0.0:9092->9092/tcp, :::9092->9092/tcp, 0.0.0.0:9644->9644/tcp, :::9644->9644/tcp, 0.0.0.0:29092->29092/tcp, :::29092->29092/tcp
```

After the application starts, 
log into the Redpanda container and send a message to the queue topic `order` as follows.

```bash
$ docker compose exec redpanda /bin/bash
redpanda@1add2615774b:/$ cd /app
redpanda@1add2615774b:/app$ cat order.json | rpk topic produce order
Produced to partition 0 at offset 0 with timestamp 1667922788523.
```

To see the data in the database container, you can use the following commands.

```bash
$ docker compose exec db /bin/bash
root@c97c472db02e:/# mysql -u root -pwhalehello mysql
mysql> select * from orders;
... ...
```


```

**/home/ophil/src/awesome-pods/wasmedge-mysql-nginx/compose.yaml**
```
services:
  frontend:
    image: nginx:alpine
    ports:
      - 8090:80
    volumes:
      - ./frontend:/usr/share/nginx/html

  backend:
    image: demo-microservice
    platform: wasi/wasm
    build:
      context: backend/
    ports:
      - 8080:8080
    environment:
      DATABASE_URL: mysql://root:whalehello@db:3306/mysql
      RUST_BACKTRACE: full
    restart: unless-stopped
    runtime: io.containerd.wasmedge.v1

  db:
    image: mariadb:10.9
    environment:
      MYSQL_ROOT_PASSWORD: whalehello

```

**/home/ophil/src/awesome-pods/wasmedge-mysql-nginx/README.md**
```
# Compose sample application

![Compatible with Docker+Wasm](../icon_wasm.svg)

This sample demonstrates a web application with a WebAssembly (Wasm) microservice, written in Rust. The Wasm microservice is an HTTP API connected to a MySQL (MariaDB) database. The API is invoked via from JavaScript in a web interface serving static HTML. The microservice is compiled into WebAssembly (Wasm) and runs in the WasmEdge Runtime, a secure and lightweight alternative to natively compiled Rust apps in Linux containers. Checkout [this article](https://blog.logrocket.com/rust-microservices-server-side-webassembly/) or [this video](https://www.youtube.com/watch?v=VSqMPFr7SEs) to learn how the Rust code in this microservice works.

## WasmEdge server with Nginx proxy and MySQL database

Project structure:

```
.
+-- compose.yml
|-- backend
    +-- Dockerfile
    |-- Cargo.toml
    |-- src
        +-- main.rs
|-- frontend
    +-- index.html
    |-- js
        +-- app.js
|-- db
    +-- orders.json
    |-- update_order.json
```

The [compose.yml](compose.yml) file:

```yaml
services:
  frontend:
    image: nginx:alpine
    ports:
      - 8090:80
    volumes:
      - ./frontend:/usr/share/nginx/html

  backend:
    image: demo-microservice
    build:
      context: backend/
      platforms:
        - wasi/wasm32
    ports:
      - 8080:8080
    environment:
      DATABASE_URL: mysql://root:whalehello@db:3306/mysql
      RUST_BACKTRACE: full
    restart: unless-stopped
    runtime: io.containerd.wasmedge.v1

  db:
    image: mariadb:10.9
    environment:
      MYSQL_ROOT_PASSWORD: whalehello
```

The compose file defines an application with three services `frontend`, `backend` and `db`. The `frontend` is a simple Nginx server that hosts static web pages that access the `backend` web service, in the WasmEdge container, via HTTP port 8080. When deploying the application, docker compose maps port 8090 of the `frontend` service container to port 8090 of the host as specified in the file. Make sure that ports 8090 and 8080 on the host are not already being used.

## Deploy with docker compose

```bash
$ docker compose up -d
...
 ⠿ Network wasmedge-mysql-nginx_default       Created
 ⠿ Container wasmedge-mysql-nginx-db-1        Created
 ⠿ Container wasmedge-mysql-nginx-frontend-1  Created
 ⠿ Container wasmedge-mysql-nginx-backend-1   Created
```

## Expected result

```bash
$ docker compose ps
NAME                              COMMAND                  SERVICE             STATUS              PORTS
wasmedge-mysql-nginx-backend-1    "order_demo_service.…"   backend             running             0.0.0.0:8080->8080/tcp, :::8080->8080/tcp
wasmedge-mysql-nginx-db-1         "docker-entrypoint.s…"   db                  running             3306/tcp
wasmedge-mysql-nginx-frontend-1   "/docker-entrypoint.…"   frontend            running             0.0.0.0:8090->80/tcp, :::8090->80/tcp
```

After the application starts, go to `http://localhost:8090` in your web browser to display the web frontend. 

### Using the API with `curl`

As an alternative to the web frontend, you can use `curl` to interact with the WasmEdge API directly (the `backend` service).

When the WasmEdge web service receives a GET request to the `/init` endpoint, it would initialize the database with the `orders` table.

```bash
curl http://localhost:8080/init
```

When the WasmEdge web service receives a POST request to the `/create_order` endpoint, it extracts the JSON data from the POST body and inserts an `Order` record into the database table.
To insert multiple records, use the `/create_orders` endpoint and POST a JSON array of `Order` objects:

```bash
curl http://localhost:8080/create_orders -X POST -d @db/orders.json
```

When the WasmEdge web service receives a GET request to the `/orders` endpoint, it gets all rows from the `orders` table and return the result set in a JSON array in the HTTP response.

```bash
curl http://localhost:8080/orders
```

When the WasmEdge web service receives a POST request to the `/update_order` endpoint, it extracts the JSON data from the POST body and update the `Order` record in the database table that matches the `order_id` in the input data.

```bash
curl http://localhost:8080/update_order -X POST -d @db/update_order.json
```

When the WasmEdge web service receives a GET request to the `/delete_order` endpoint, it deletes the row in the `orders` table that matches the `id` GET parameter.

```bash
curl http://localhost:8080/delete_order?id=2
```


```

**/home/ophil/src/awesome-pods/react-express-mongodb/compose.yaml**
```
services:
  frontend:
    build:
      context: frontend
      target: development
    ports:
      - 3000:3000
    stdin_open: true
    volumes:
      - ./frontend:/usr/src/app
      - /usr/src/app/node_modules
    restart: always
    networks:
      - react-express
    depends_on:
      - backend

  backend:
    restart: always
    build:
      context: backend
      target: development
    volumes:
      - ./backend:/usr/src/app
      - /usr/src/app/node_modules
    depends_on:
      - mongo
    networks:
      - express-mongo
      - react-express
    expose: 
      - 3000
  mongo:
    restart: always
    image: mongo:4.2.0
    volumes:
      - mongo_data:/data/db
    networks:
      - express-mongo
    expose:
      - 27017
networks:
  react-express:
  express-mongo:

volumes:
  mongo_data:

```

**/home/ophil/src/awesome-pods/react-express-mysql/compose.yaml**
```
services:
  backend:
    build:
      args:
      - NODE_ENV=development
      context: backend
      target: development
    command: npm run start-watch
    environment:
      - DATABASE_DB=example
      - DATABASE_USER=root
      - DATABASE_PASSWORD=/run/secrets/db-password
      - DATABASE_HOST=db
      - NODE_ENV=development
    ports:
      - 80:80
      - 9229:9229
      - 9230:9230
    secrets:
      - db-password
    volumes:
      - ./backend/src:/code/src:ro
      - ./backend/package.json:/code/package.json
      - ./backend/package-lock.json:/code/package-lock.json
      - back-notused:/opt/app/node_modules
    networks:
      - public
      - private
    depends_on:
      - db
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10.6.4-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8.0.27
    command: '--default-authentication-plugin=mysql_native_password'
    restart: always
    secrets:
      - db-password
    volumes:
      - db-data:/var/lib/mysql
    networks:
      - private
    environment:
      - MYSQL_DATABASE=example
      - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db-password
  frontend:
    build:
      context: frontend
      target: development
    ports:
      - 3000:3000
    volumes:
      - ./frontend/src:/code/src
      - /code/node_modules
    networks:
      - public
    depends_on:
      - backend
networks:
  public:
  private:
volumes:
  back-notused:
  db-data:
secrets:
  db-password:
    file: db/password.txt

```

**/home/ophil/src/awesome-pods/react-java-mysql/compose.yaml**
```
services:
  backend:
    build: backend
    restart: always
    secrets:
      - db-password
    environment:
      MYSQL_HOST: db
    networks:
      - react-spring
      - spring-mysql
    depends_on:
      db:
        condition: service_healthy
  db:
    # We use a mariadb image which supports both amd64 & arm64 architecture
    image: mariadb:10.6.4-focal
    # If you really want to use MySQL, uncomment the following line
    #image: mysql:8.0.19
    environment:
      - MYSQL_DATABASE=example
      - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db-password
    restart: always
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "--silent"]
      interval: 3s
      retries: 5
      start_period: 30s
    secrets:
      - db-password
    volumes:
      - db-data:/var/lib/mysql
    networks:
      - spring-mysql
  frontend:
    build:
      context: frontend
      target: development
    ports:
      - 3000:3000
    volumes:
      - ./frontend/src:/code/src
      - /project/node_modules
    networks:
      - react-spring
    depends_on:
      - backend
    expose:
      - 3306
      - 33060
volumes:
  db-data: {}
secrets:
  db-password:
    file: db/password.txt
networks:
  react-spring: {}
  spring-mysql: {}

```

**/home/ophil/src/awesome-pods/react-rust-postgres/compose.yaml**
```
name: react-rust-postgres
services:
  frontend:
    build:
      context: frontend
      target: development
    networks:
      - client-side
    ports:
      - 3000:3000
    volumes:
      - ./frontend/src:/code/src:ro

  backend:
    build:
      context: backend
      target: development
    environment:
      - ADDRESS=0.0.0.0:8000
      - RUST_LOG=debug
      - PG_DBNAME=postgres
      - PG_HOST=db
      - PG_USER=postgres
      - PG_PASSWORD=mysecretpassword
    networks:
      - client-side
      - server-side
    volumes:
      - ./backend/src:/code/src
      - backend-cache:/code/target
    depends_on:
      - db

  db:
    image: postgres:12-alpine
    restart: always
    environment:
      - POSTGRES_PASSWORD=mysecretpassword
    networks:
      - server-side
    ports:
      - 5432:5432
    volumes:
      - db-data:/var/lib/postgresql/data

networks:
  client-side: {}
  server-side: {}

volumes:
  backend-cache: {}
  db-data: {}

```





**Files Read:**

**/home/ophil/src/awesome-pods/nginx-aspnet-mysql/backend/Dockerfile**
```
# syntax=docker/dockerfile:1.4

FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:6.0 AS base

WORKDIR /src

COPY aspnetapp.csproj ./
RUN ["dotnet", "restore"]

FROM base as builder

COPY . .

CMD ["dotnet", "build", "-c", "-o", "/build"]

FROM builder as dev-envs

RUN <<EOF
apt-get update
apt-get install -y git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /

CMD ["dotnet", "run"]

FROM builder AS publisher

RUN ["dotnet", "publish", "-c", "Release", "-o", "/build"]

FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/aspnet:6.0

WORKDIR /app
COPY --from=publisher /build .

CMD ["dotnet", "aspnetapp.dll"]

```

**/home/ophil/src/awesome-pods/nginx-aspnet-mysql/proxy/Dockerfile**
```
FROM nginx:1.13-alpine
COPY conf /etc/nginx/conf.d/default.conf
```

**/home/ophil/src/awesome-pods/nginx-flask-mongo/flask/Dockerfile**
```
# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM python:3.10-alpine AS builder

WORKDIR /src
COPY requirements.txt /src
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

COPY . .

CMD ["python3", "server.py"]

FROM builder as dev-envs

RUN <<EOF
apk update
apk add git
EOF

RUN <<EOF
addgroup -S docker
adduser -S --shell /bin/bash --ingroup docker vscode
EOF

# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /

CMD ["python3", "server.py"]

```

**/home/ophil/src/awesome-pods/nginx-flask-mongo/nginx/nginx.conf**
```
server {
  listen 80;
  location / {
    proxy_pass http://$FLASK_SERVER_ADDR;
  }
}

```

**/home/ophil/src/awesome-pods/nginx-golang-mysql/backend/Dockerfile**
```
# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM golang:1.18-alpine AS builder

WORKDIR /code

ENV CGO_ENABLED 0
ENV GOPATH /go
ENV GOCACHE /go-build

COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod/cache \
    go mod download

COPY . .

RUN --mount=type=cache,target=/go/pkg/mod/cache \
    --mount=type=cache,target=/go-build \
    go build -o bin/backend main.go

CMD ["/code/bin/backend"]

FROM builder AS dev-envs

RUN <<EOF
apk update
apk add git
EOF

RUN <<EOF
addgroup -S docker
adduser -S --shell /bin/bash --ingroup docker vscode
EOF

# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /

CMD ["go", "run", "main.go"]

FROM scratch
COPY --from=builder /code/bin/backend /usr/local/bin/backend
CMD ["/usr/local/bin/backend"]

```

**/home/ophil/src/awesome-pods/nginx-golang-mysql/proxy/nginx.conf**
```
server {
    listen       80;
    server_name  localhost;
    location / {
        proxy_pass          http://backend:8000;
        proxy_http_version  1.1;
    }
}

```

**/home/ophil/src/awesome-pods/nginx-golang/backend/Dockerfile**
```
# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM golang:1.18-alpine AS builder

WORKDIR /code

ENV CGO_ENABLED 0
ENV GOPATH /go
ENV GOCACHE /go-build

COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod/cache \
    go mod download

COPY . .

RUN --mount=type=cache,target=/go/pkg/mod/cache \
    --mount=type=cache,target=/go-build \
    go build -o bin/backend main.go

CMD ["/code/bin/backend"]

FROM builder as dev-envs

RUN <<EOF
apk update
apk add git
EOF

RUN <<EOF
addgroup -S docker
adduser -S --shell /bin/bash --ingroup docker vscode
EOF

# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /

CMD ["go", "run", "main.go"]

FROM scratch
COPY --from=builder /code/bin/backend /usr/local/bin/backend
CMD ["/usr/local/bin/backend"]

```

**/home/ophil/src/awesome-pods/nginx-nodejs-redis/web/Dockerfile**
```
FROM node:14.17.3-alpine3.14

WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm ci
COPY ./server.js ./

CMD ["npm","start"]

```

**/home/ophil/src/awesome-pods/nginx-nodejs-redis/nginx/Dockerfile**
```
FROM nginx:1.21.6
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

```

**/home/ophil/src/awesome-pods/nginx-wsgi-flask/flask/Dockerfile**
```
FROM python:3.9.2-alpine

# upgrade pip
RUN pip install --upgrade pip

# get curl for healthchecks
RUN apk add curl

# permissions and nonroot user for tightened security
RUN adduser -D nonroot
RUN mkdir /home/app/ && chown -R nonroot:nonroot /home/app
RUN mkdir -p /var/log/flask-app && touch /var/log/flask-app/flask-app.err.log && touch /var/log/flask-app/flask-app.out.log
RUN chown -R nonroot:nonroot /var/log/flask-app
WORKDIR /home/app
USER nonroot

# copy all the files to the container
COPY --chown=nonroot:nonroot . .

# venv
ENV VIRTUAL_ENV=/home/app/venv

# python setup
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN export FLASK_APP=app.py
RUN pip install -r requirements.txt

# define the port number the container should expose
EXPOSE 5000

CMD ["python", "app.py"]
```

**/home/ophil/src/awesome-pods/nginx-wsgi-flask/nginx/Dockerfile**
```
FROM nginx:1.19.7-alpine

# Add bash for boot cmd
RUN apk add bash

# Add nginx.conf to container
COPY --chown=nginx:nginx nginx.conf /etc/nginx/nginx.conf
COPY --chown=nginx:nginx start.sh /app/start.sh

# set workdir
WORKDIR /app

# permissions and nginx user for tightened security
RUN chown -R nginx:nginx /app && chmod -R 755 /app && \
        chown -R nginx:nginx /var/cache/nginx && \
        chown -R nginx:nginx /var/log/nginx && \
        chmod -R 755 /var/log/nginx; \
        chown -R nginx:nginx /etc/nginx/conf.d
RUN touch /var/run/nginx.pid && chown -R nginx:nginx /var/run/nginx.pid

# # Uncomment to keep the nginx logs inside the container - Leave commented for logging to stdout and stderr
# RUN mkdir -p /var/log/nginx
# RUN unlink /var/log/nginx/access.log \
#     && unlink /var/log/nginx/error.log \
#     && touch /var/log/nginx/access.log \
#     && touch /var/log/nginx/error.log \
#     && chown nginx /var/log/nginx/*log \
#     && chmod 644 /var/log/nginx/*log

USER nginx

CMD ["nginx", "-g", "'daemon off;'"]

```

**/home/ophil/src/awesome-pods/nginx-wsgi-flask/nginx/start.sh**
```
#!/bin/bash
envsubst '$FLASK_SERVER_ADDR' < /tmp/default.conf > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'

```

**/home/ophil/src/awesome-pods/react-express-mongodb/backend/Dockerfile**
```
# syntax=docker/dockerfile:1.4

FROM node:lts-buster-slim AS development

# Create app directory
WORKDIR /usr/src/app

COPY package.json /usr/src/app/package.json
COPY package-lock.json /usr/src/app/package-lock.json
RUN npm ci

COPY . /usr/src/app

EXPOSE 3000

CMD [ "npm", "run", "dev" ]

FROM development as dev-envs
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD [ "npm", "run", "dev" ]
```

**/home/ophil/src/awesome-pods/react-express-mongodb/frontend/Dockerfile**
```
# syntax=docker/dockerfile:1.4

# Create image based on the official Node image from dockerhub
FROM node:lts-buster AS development

# Create app directory
WORKDIR /usr/src/app

# Copy dependency definitions
COPY package.json /usr/src/app
COPY package-lock.json /usr/src/app

# Install dependecies
#RUN npm set progress=false \
#    && npm config set depth 0 \
#    && npm i install
RUN npm ci

# Get all the code needed to run the app
COPY . /usr/src/app

# Expose the port the app runs in
EXPOSE 3000

# Serve the app
CMD ["npm", "start"]

FROM development as dev-envs
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD [ "npm", "start" ]

```

**/home/ophil/src/awesome-pods/react-express-mysql/backend/Dockerfile**
```
# syntax=docker/dockerfile:1.4

# if you're doing anything beyond your local machine, please pin this to a specific version at https://hub.docker.com/_/node/
FROM node:lts AS development

# set our node environment, either development or production
# defaults to production, compose overrides this to development on build and run
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

WORKDIR /code

# default to port 80 for node, and 9229 and 9230 (tests) for debug
ARG PORT=80
ENV PORT $PORT
EXPOSE $PORT 9229 9230

COPY package.json /code/package.json
COPY package-lock.json /code/package-lock.json
RUN npm ci

# check every 30s to ensure this service returns HTTP 200
HEALTHCHECK --interval=30s \
  CMD node healthcheck.js

# copy in our source code last, as it changes the most
COPY . /code

# if you want to use npm start instead, then use `docker run --init in production`
# so that signals are passed properly. Note the code in index.js is needed to catch Docker signals
# using node here is still more graceful stopping then npm with --init afaik
# I still can't come up with a good production way to run with npm and graceful shutdown
CMD [ "node", "src/index.js" ]

FROM development as dev-envs
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /

```

**/home/ophil/src/awesome-pods/react-express-mysql/frontend/Dockerfile**
```
# syntax=docker/dockerfile:1.4

FROM node:lts AS development

ENV CI=true
ENV PORT=3000

WORKDIR /code
COPY package.json /code/package.json
COPY package-lock.json /code/package-lock.json
RUN npm ci
COPY . /code

CMD [ "npm", "start" ]

FROM development AS builder

RUN npm run build

FROM development as dev-envs
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD [ "npm", "start" ]

FROM nginx:1.13-alpine

COPY --from=builder /code/build /usr/share/nginx/html

```

**/home/ophil/src/awesome-pods/react-java-mysql/backend/Dockerfile**
```
# syntax=docker/dockerfile:1.4

FROM --platform=$BUILDPLATFORM maven:3.8.5-eclipse-temurin-17 AS builder
WORKDIR /workdir/server
COPY pom.xml /workdir/server/pom.xml
RUN mvn dependency:go-offline

COPY src /workdir/server/src
RUN mvn install

FROM builder as dev-envs

RUN <<EOF
apt-get update
apt-get install -y git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD ["mvn", "spring-boot:run"]

FROM builder as prepare-production
RUN mkdir -p target/dependency
WORKDIR /workdir/server/target/dependency
RUN jar -xf ../*.jar

FROM eclipse-temurin:17-jre-focal

EXPOSE 8080
VOLUME /tmp
ARG DEPENDENCY=/workdir/server/target/dependency
COPY --from=prepare-production ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=prepare-production ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=prepare-production ${DEPENDENCY}/BOOT-INF/classes /app
ENTRYPOINT ["java","-cp","app:app/lib/*","com.company.project.Application"]
```

**/home/ophil/src/awesome-pods/react-java-mysql/frontend/Dockerfile**
```
# syntax=docker/dockerfile:1.4

FROM --platform=$BUILDPLATFORM node:lts AS development

WORKDIR /code
COPY package.json /code/package.json
COPY package-lock.json /code/package-lock.json

RUN npm ci
COPY . /code

ENV CI=true
ENV PORT=3000

CMD [ "npm", "start" ]

FROM development AS dev-envs
RUN <<EOF
apt-get update
apt-get install -y git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD [ "npm", "start" ]

FROM development AS build

RUN ["npm", "run", "build"]

FROM nginx:1.13-alpine

COPY --from=build /code/build /usr/share/nginx/html

```

**/home/ophil/src/awesome-pods/react-rust-postgres/backend/Dockerfile**
```
# syntax=docker/dockerfile:1.4
FROM rust:buster AS base

ENV USER=root
ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_ENV=development

WORKDIR /code
RUN cargo init
COPY Cargo.toml /code/Cargo.toml
RUN cargo fetch
COPY . /code

FROM base AS development

EXPOSE 8000

CMD [ "cargo", "run", "--offline" ]

FROM base AS dev-envs

EXPOSE 8000
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD [ "cargo", "run", "--offline" ]

FROM base AS builder

RUN cargo build --release --offline

FROM debian:buster-slim

ENV ROCKET_ENV=production

EXPOSE 8000

COPY --from=builder /code/target/release/react-rust-postgres /react-rust-postgres

CMD [ "/react-rust-postgres" ]

```

**/home/ophil/src/awesome-pods/react-rust-postgres/frontend/Dockerfile**
```
# syntax=docker/dockerfile:1.4
FROM node:lts AS development

ENV CI=true
ENV PORT=3000

WORKDIR /code
COPY package.json /code/package.json
COPY package-lock.json /code/package-lock.json
RUN npm ci
COPY . /code

CMD [ "npm", "start" ]

FROM development as dev-envs
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD [ "npm", "start" ]

FROM development AS builder

RUN npm run build

FROM nginx:1.13-alpine

COPY --from=builder /code/build /usr/share/nginx/html

```





**Files Read:**

**/home/ophil/src/awesome-pods/nginx-golang/proxy/nginx.conf**
```
server {
  listen 80;
  location / {
    proxy_pass http://backend:80;
  }
}
```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/nextcloud-redis-mariadb/kube.yaml
+++ /home/ophil/src/awesome-pods/nextcloud-redis-mariadb/kube.yaml
@@ -0,0 +1,56 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: nextcloud-redis-mariadb
+  labels:
+    app: nextcloud-redis-mariadb
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: mariadb:10.5
+      args:
+        - "--transaction-isolation=READ-COMMITTED"
+        - "--binlog-format=ROW"
+      env:
+        - name: MYSQL_DATABASE
+          value: "nextcloud"
+        - name: MYSQL_USER
+          value: "nextcloud"
+        - name: MYSQL_PASSWORD
+          value: "nextcloud"
+        - name: MYSQL_ROOT_PASSWORD
+          value: "nextcloud"
+      ports:
+        - containerPort: 3306
+      volumeMounts:
+        - name: db-data
+          mountPath: /var/lib/mysql
+    - name: redis
+      image: redis:alpine
+      ports:
+        - containerPort: 6379
+    - name: nc
+      image: nextcloud:apache
+      env:
+        - name: REDIS_HOST
+          value: "redis"
+        - name: MYSQL_HOST
+          value: "db"
+        - name: MYSQL_DATABASE
+          value: "nextcloud"
+        - name: MYSQL_USER
+          value: "nextcloud"
+        - name: MYSQL_PASSWORD
+          value: "nextcloud"
+      ports:
+        - containerPort: 80
+          hostPort: 80
+      volumeMounts:
+        - name: nc-data
+          mountPath: /var/www/html
+  volumes:
+    - name: db-data
+      emptyDir: {}
+    - name: nc-data
+      emptyDir: {}

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/nginx-aspnet-mysql/kube.yaml
+++ /home/ophil/src/awesome-pods/nginx-aspnet-mysql/kube.yaml
@@ -0,0 +1,44 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: nginx-aspnet-mysql
+  labels:
+    app: nginx-aspnet-mysql
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: mariadb:10-focal
+      args:
+        - "--default-authentication-plugin=mysql_native_password"
+      env:
+        - name: MYSQL_DATABASE
+          value: "example"
+        - name: MYSQL_ROOT_PASSWORD
+          value: "example"
+      ports:
+        - containerPort: 3306
+      volumeMounts:
+        - name: db-data
+          mountPath: /var/lib/mysql
+    - name: backend
+      image: nginx-aspnet-backend
+      env:
+        - name: ASPNETCORE_URLS
+          value: "http://+:8000"
+      ports:
+        - containerPort: 8000
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 8000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: proxy
+      image: nginx-aspnet-proxy
+      ports:
+        - containerPort: 80
+          hostPort: 80
+  volumes:
+    - name: db-data
+      emptyDir: {}

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/nginx-flask-mongo/kube.yaml
+++ /home/ophil/src/awesome-pods/nginx-flask-mongo/kube.yaml
@@ -0,0 +1,51 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: nginx-flask-mongo
+  labels:
+    app: nginx-flask-mongo
+spec:
+  restartPolicy: Always
+  containers:
+    - name: web
+      image: nginx:latest
+      env:
+        - name: FLASK_SERVER_ADDR
+          value: "backend:9091"
+      command:
+        - /bin/bash
+        - -c
+        - "envsubst < /tmp/nginx.conf > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
+      ports:
+        - containerPort: 80
+          hostPort: 80
+      volumeMounts:
+        - name: nginx-config
+          mountPath: /tmp/nginx.conf
+          subPath: nginx.conf
+    - name: backend
+      image: nginx-flask-mongo-backend
+      env:
+        - name: FLASK_SERVER_PORT
+          value: "9091"
+      ports:
+        - containerPort: 9091
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 9091
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: mongo
+      image: mongo:latest
+      ports:
+        - containerPort: 27017
+      volumeMounts:
+        - name: mongo-data
+          mountPath: /data/db
+  volumes:
+    - name: nginx-config
+      hostPath:
+        path: ./nginx
+    - name: mongo-data
+      emptyDir: {}

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/nginx-golang-mysql/kube.yaml
+++ /home/ophil/src/awesome-pods/nginx-golang-mysql/kube.yaml
@@ -0,0 +1,48 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: nginx-golang-mysql
+  labels:
+    app: nginx-golang-mysql
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: mariadb:10-focal
+      args:
+        - "--default-authentication-plugin=mysql_native_password"
+      env:
+        - name: MYSQL_DATABASE
+          value: "example"
+        - name: MYSQL_ROOT_PASSWORD
+          value: "example"
+      ports:
+        - containerPort: 3306
+      volumeMounts:
+        - name: db-data
+          mountPath: /var/lib/mysql
+    - name: backend
+      image: nginx-golang-mysql-backend
+      ports:
+        - containerPort: 8000
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 8000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: proxy
+      image: nginx:latest
+      ports:
+        - containerPort: 80
+          hostPort: 80
+      volumeMounts:
+        - name: nginx-config
+          mountPath: /etc/nginx/conf.d/default.conf
+          subPath: nginx.conf
+  volumes:
+    - name: db-data
+      emptyDir: {}
+    - name: nginx-config
+      hostPath:
+        path: ./proxy

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/nginx-golang-postgres/kube.yaml
+++ /home/ophil/src/awesome-pods/nginx-golang-postgres/kube.yaml
@@ -0,0 +1,52 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: nginx-golang-postgres
+  labels:
+    app: nginx-golang-postgres
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: postgres:latest
+      env:
+        - name: POSTGRES_DB
+          value: "example"
+        - name: POSTGRES_PASSWORD
+          value: "example"
+      ports:
+        - containerPort: 5432
+      volumeMounts:
+        - name: db-data
+          mountPath: /var/lib/postgresql/data
+      livenessProbe:
+        exec:
+          command:
+            - pg_isready
+        initialDelaySeconds: 20
+        periodSeconds: 30
+    - name: backend
+      image: nginx-golang-postgres-backend
+      ports:
+        - containerPort: 8000
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 8000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: proxy
+      image: nginx:latest
+      ports:
+        - containerPort: 80
+          hostPort: 80
+      volumeMounts:
+        - name: nginx-config
+          mountPath: /etc/nginx/conf.d/default.conf
+          subPath: nginx.conf
+  volumes:
+    - name: db-data
+      emptyDir: {}
+    - name: nginx-config
+      hostPath:
+        path: ./proxy

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/nginx-golang/kube.yaml
+++ /home/ophil/src/awesome-pods/nginx-golang/kube.yaml
@@ -0,0 +1,32 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: nginx-golang
+  labels:
+    app: nginx-golang
+spec:
+  restartPolicy: Always
+  containers:
+    - name: backend
+      image: nginx-golang-backend
+      ports:
+        - containerPort: 80
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 80
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: proxy
+      image: nginx:latest
+      ports:
+        - containerPort: 80
+          hostPort: 80
+      volumeMounts:
+        - name: nginx-config
+          mountPath: /etc/nginx/conf.d/default.conf
+          subPath: nginx.conf
+  volumes:
+    - name: nginx-config
+      hostPath:
+        path: ./proxy

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/nginx-nodejs-redis/kube.yaml
+++ /home/ophil/src/awesome-pods/nginx-nodejs-redis/kube.yaml
@@ -0,0 +1,47 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: nginx-nodejs-redis
+  labels:
+    app: nginx-nodejs-redis
+spec:
+  restartPolicy: Always
+  containers:
+    - name: redis
+      image: redislabs/redismod
+      ports:
+        - containerPort: 6379
+          hostPort: 6379
+    - name: web1
+      image: nginx-nodejs-redis-web
+      env:
+        - name: REDIS_HOST
+          value: "redis"
+      ports:
+        - containerPort: 5000
+          hostPort: 81
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 5000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: web2
+      image: nginx-nodejs-redis-web
+      env:
+        - name: REDIS_HOST
+          value: "redis"
+      ports:
+        - containerPort: 5000
+          hostPort: 82
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 5000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: nginx
+      image: nginx-nodejs-redis-nginx
+      ports:
+        - containerPort: 80
+          hostPort: 80

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/nginx-wsgi-flask/kube.yaml
+++ /home/ophil/src/awesome-pods/nginx-wsgi-flask/kube.yaml
@@ -0,0 +1,42 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: nginx-wsgi-flask
+  labels:
+    app: nginx-wsgi-flask
+spec:
+  restartPolicy: Always
+  containers:
+    - name: flask-app
+      image: nginx-wsgi-flask-flask
+      ports:
+        - containerPort: 8000
+          hostPort: 8000
+      livenessProbe:
+        httpGet:
+          path: /flask-health-check
+          port: 8000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: nginx-proxy
+      image: nginx-wsgi-flask-nginx
+      env:
+        - name: FLASK_SERVER_ADDR
+          value: "flask-app:8000"
+      ports:
+        - containerPort: 80
+          hostPort: 80
+      volumeMounts:
+        - name: nginx-default
+          mountPath: /tmp/default.conf
+          subPath: default.conf
+      livenessProbe:
+        httpGet:
+          path: /health-check
+          port: 80
+        initialDelaySeconds: 10
+        periodSeconds: 30
+  volumes:
+    - name: nginx-default
+      hostPath:
+        path: ./nginx

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/pihole-cloudflared-DoH/kube.yaml
+++ /home/ophil/src/awesome-pods/pihole-cloudflared-DoH/kube.yaml
@@ -0,0 +1,74 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: pihole-cloudflared
+  labels:
+    app: pihole-cloudflared
+spec:
+  restartPolicy: Always
+  containers:
+    - name: cloudflared
+      image: visibilityspots/cloudflared
+      env:
+        - name: TZ
+          value: "UTC"
+        - name: PORT
+          value: "5054"
+        - name: ADDRESS
+          value: "0.0.0.0"
+      ports:
+        - containerPort: 5054
+          hostPort: 5054
+          protocol: TCP
+        - containerPort: 5054
+          hostPort: 5054
+          protocol: UDP
+    - name: pihole
+      image: pihole/pihole:latest
+      env:
+        - name: TZ
+          value: "UTC"
+        - name: PIHOLE_DNS_
+          value: "172.20.0.2#5054;1.1.1.1"
+        - name: WEBPASSWORD
+          value: "changeme"
+        - name: REV_SERVER
+          value: "true"
+        - name: REV_SERVER_TARGET
+          value: "192.168.1.1"
+        - name: REV_SERVER_DOMAIN
+          value: "example.local"
+        - name: REV_SERVER_CIDR
+          value: "192.168.1.0/24"
+        - name: ServerIP
+          value: "127.0.0.1"
+      securityContext:
+        capabilities:
+          add:
+            - NET_ADMIN
+      ports:
+        - containerPort: 53
+          hostPort: 53
+          protocol: TCP
+        - containerPort: 53
+          hostPort: 53
+          protocol: UDP
+        - containerPort: 67
+          hostPort: 67
+          protocol: UDP
+        - containerPort: 80
+          hostPort: 8080
+        - containerPort: 443
+          hostPort: 8443
+      volumeMounts:
+        - name: pihole-etc
+          mountPath: /etc/pihole
+        - name: pihole-dnsmasq
+          mountPath: /etc/dnsmasq.d
+  volumes:
+    - name: pihole-etc
+      hostPath:
+        path: /etc/pihole
+    - name: pihole-dnsmasq
+      hostPath:
+        path: /etc/dnsmasq.d

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/react-express-mongodb/kube.yaml
+++ /home/ophil/src/awesome-pods/react-express-mongodb/kube.yaml
@@ -0,0 +1,40 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: react-express-mongodb
+  labels:
+    app: react-express-mongodb
+spec:
+  restartPolicy: Always
+  containers:
+    - name: mongo
+      image: mongo:4.2.0
+      ports:
+        - containerPort: 27017
+      volumeMounts:
+        - name: mongo-data
+          mountPath: /data/db
+    - name: backend
+      image: react-express-mongodb-backend
+      ports:
+        - containerPort: 3000
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 3000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: frontend
+      image: react-express-mongodb-frontend
+      ports:
+        - containerPort: 3000
+          hostPort: 3000
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 3000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+  volumes:
+    - name: mongo-data
+      emptyDir: {}

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/react-express-mysql/kube.yaml
+++ /home/ophil/src/awesome-pods/react-express-mysql/kube.yaml
@@ -0,0 +1,63 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: react-express-mysql
+  labels:
+    app: react-express-mysql
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: mariadb:10.6.4-focal
+      args:
+        - "--default-authentication-plugin=mysql_native_password"
+      env:
+        - name: MYSQL_DATABASE
+          value: "example"
+        - name: MYSQL_ROOT_PASSWORD
+          value: "example"
+      ports:
+        - containerPort: 3306
+      volumeMounts:
+        - name: db-data
+          mountPath: /var/lib/mysql
+    - name: backend
+      image: react-express-mysql-backend
+      env:
+        - name: DATABASE_DB
+          value: "example"
+        - name: DATABASE_USER
+          value: "root"
+        - name: DATABASE_PASSWORD
+          value: "example"
+        - name: DATABASE_HOST
+          value: "db"
+        - name: NODE_ENV
+          value: "development"
+      ports:
+        - containerPort: 80
+          hostPort: 80
+        - containerPort: 9229
+          hostPort: 9229
+        - containerPort: 9230
+          hostPort: 9230
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 80
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: frontend
+      image: react-express-mysql-frontend
+      ports:
+        - containerPort: 3000
+          hostPort: 3000
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 3000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+  volumes:
+    - name: db-data
+      emptyDir: {}

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/react-java-mysql/kube.yaml
+++ /home/ophil/src/awesome-pods/react-java-mysql/kube.yaml
@@ -0,0 +1,48 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: react-java-mysql
+  labels:
+    app: react-java-mysql
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: mariadb:10.6.4-focal
+      env:
+        - name: MYSQL_DATABASE
+          value: "example"
+        - name: MYSQL_ROOT_PASSWORD
+          value: "example"
+      ports:
+        - containerPort: 3306
+      volumeMounts:
+        - name: db-data
+          mountPath: /var/lib/mysql
+    - name: backend
+      image: react-java-mysql-backend
+      env:
+        - name: MYSQL_HOST
+          value: "db"
+      ports:
+        - containerPort: 8080
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 8080
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: frontend
+      image: react-java-mysql-frontend
+      ports:
+        - containerPort: 3000
+          hostPort: 3000
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 3000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+  volumes:
+    - name: db-data
+      emptyDir: {}

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/react-rust-postgres/kube.yaml
+++ /home/ophil/src/awesome-pods/react-rust-postgres/kube.yaml
@@ -0,0 +1,57 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: react-rust-postgres
+  labels:
+    app: react-rust-postgres
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: postgres:12-alpine
+      env:
+        - name: POSTGRES_PASSWORD
+          value: "mysecretpassword"
+      ports:
+        - containerPort: 5432
+          hostPort: 5432
+      volumeMounts:
+        - name: db-data
+          mountPath: /var/lib/postgresql/data
+    - name: backend
+      image: react-rust-postgres-backend
+      env:
+        - name: ADDRESS
+          value: "0.0.0.0:8000"
+        - name: RUST_LOG
+          value: "debug"
+        - name: PG_DBNAME
+          value: "postgres"
+        - name: PG_HOST
+          value: "db"
+        - name: PG_USER
+          value: "postgres"
+        - name: PG_PASSWORD
+          value: "mysecretpassword"
+      ports:
+        - containerPort: 8000
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 8000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+    - name: frontend
+      image: react-rust-postgres-frontend
+      ports:
+        - containerPort: 3000
+          hostPort: 3000
+      livenessProbe:
+        httpGet:
+          path: "/"
+          port: 3000
+        initialDelaySeconds: 10
+        periodSeconds: 30
+  volumes:
+    - name: db-data
+      emptyDir: {}

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/wasmedge-kafka-mysql/kube.yaml
+++ /home/ophil/src/awesome-pods/wasmedge-kafka-mysql/kube.yaml
@@ -0,0 +1,63 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: wasmedge-kafka-mysql
+  labels:
+    app: wasmedge-kafka-mysql
+spec:
+  restartPolicy: Always
+  containers:
+    - name: redpanda
+      image: docker.redpanda.com/vectorized/redpanda:v22.2.2
+      args:
+        - redpanda
+        - start
+        - --smp
+        - "1"
+        - --overprovisioned
+        - --node-id
+        - "0"
+        - --kafka-addr
+        - PLAINTEXT://0.0.0.0:29092,OUTSIDE://0.0.0.0:9092
+        - --advertise-kafka-addr
+        - PLAINTEXT://redpanda:29092,OUTSIDE://redpanda:9092
+        - --pandaproxy-addr
+        - 0.0.0.0:8082
+        - --advertise-pandaproxy-addr
+        - localhost:8082
+      ports:
+        - containerPort: 8081
+          hostPort: 8081
+        - containerPort: 8082
+          hostPort: 8082
+        - containerPort: 9092
+          hostPort: 9092
+        - containerPort: 9644
+          hostPort: 9644
+        - containerPort: 29092
+          hostPort: 29092
+      volumeMounts:
+        - name: kafka-data
+          mountPath: /app
+    - name: etl
+      image: etl-kafka
+      env:
+        - name: DATABASE_URL
+          value: "mysql://root:whalehello@db:3306/mysql"
+        - name: KAFKA_URL
+          value: "kafka://redpanda:9092/order"
+        - name: RUST_BACKTRACE
+          value: "full"
+        - name: RUST_LOG
+          value: "info"
+    - name: db
+      image: mariadb:10.9
+      env:
+        - name: MYSQL_ROOT_PASSWORD
+          value: "whalehello"
+      ports:
+        - containerPort: 3306
+  volumes:
+    - name: kafka-data
+      hostPath:
+        path: ./kafka

```





**Diff:**
```diff
--- /home/ophil/src/awesome-pods/wasmedge-mysql-nginx/kube.yaml
+++ /home/ophil/src/awesome-pods/wasmedge-mysql-nginx/kube.yaml
@@ -0,0 +1,38 @@
+apiVersion: v1
+kind: Pod
+metadata:
+  name: wasmedge-mysql-nginx
+  labels:
+    app: wasmedge-mysql-nginx
+spec:
+  restartPolicy: Always
+  containers:
+    - name: db
+      image: mariadb:10.9
+      env:
+        - name: MYSQL_ROOT_PASSWORD
+          value: "whalehello"
+      ports:
+        - containerPort: 3306
+    - name: backend
+      image: demo-microservice
+      env:
+        - name: DATABASE_URL
+          value: "mysql://root:whalehello@db:3306/mysql"
+        - name: RUST_BACKTRACE
+          value: "full"
+      ports:
+        - containerPort: 8080
+          hostPort: 8080
+    - name: frontend
+      image: nginx:alpine
+      ports:
+        - containerPort: 80
+          hostPort: 8090
+      volumeMounts:
+        - name: frontend-static
+          mountPath: /usr/share/nginx/html
+  volumes:
+    - name: frontend-static
+      hostPath:
+        path: ./frontend

```



All remaining samples with `compose.yaml` now also have a `kube.yaml` suitable for `podman kube play`. Here’s how to use them and what image tags to build.

I’ll group them briefly; you can open each `kube.yaml` in-place if you want to review details.

---

## Nextcloud variants

### `nextcloud-postgres` (already done earlier)

Run:

```bash
cd nextcloud-postgres
podman kube play kube.yaml
podman kube down kube.yaml
```
### `nextcloud-redis-mariadb`

Pod: `db` (MariaDB), `redis`, `nc` (Nextcloud). Host port `80`.

Run:

```bash
cd nextcloud-redis-mariadb
podman kube play kube.yaml
podman kube down kube.yaml
```
---

## Nginx + backend stacks

### `nginx-aspnet-mysql`

Pod: `db` (MariaDB), `backend` (.NET), `proxy` (nginx).

Build & run:

```bash
cd nginx-aspnet-mysql
podman build -t nginx-aspnet-backend backend
podman build -t nginx-aspnet-proxy proxy
podman kube play kube.yaml
podman kube down kube.yaml
```
### `nginx-flask-mongo`

Pod: `web` (nginx), `backend` (Flask), `mongo`.

Build & run:

```bash
cd nginx-flask-mongo
podman build -t nginx-flask-mongo-backend flask
podman kube play kube.yaml
podman kube down kube.yaml
```
### `nginx-golang`

Pod: `backend` (Go), `proxy` (nginx).

```bash
cd nginx-golang
podman build -t nginx-golang-backend backend
podman kube play kube.yaml
podman kube down kube.yaml
```
### `nginx-golang-mysql`

Pod: `db` (MariaDB), `backend` (Go, port 8000), `proxy` (nginx on host `80`).

```bash
cd nginx-golang-mysql
podman build -t nginx-golang-mysql-backend backend
podman kube play kube.yaml
podman kube down kube.yaml
```
### `nginx-golang-postgres`

Pod: `db` (Postgres), `backend` (Go), `proxy` (nginx).

```bash
cd nginx-golang-postgres
podman build -t nginx-golang-postgres-backend backend
podman kube play kube.yaml
podman kube down kube.yaml
```
### `nginx-nodejs-redis`

Pod: `redis`, `web1`, `web2`, `nginx`.

```bash
cd nginx-nodejs-redis
podman build -t nginx-nodejs-redis-web web
podman build -t nginx-nodejs-redis-nginx nginx
podman kube play kube.yaml
podman kube down kube.yaml
```
### `nginx-wsgi-flask`

Pod: `flask-app` (Gunicorn) on `8000`, `nginx-proxy` on host `80`.

```bash
cd nginx-wsgi-flask
podman build -t nginx-wsgi-flask-flask flask
podman build -t nginx-wsgi-flask-nginx nginx
podman kube play kube.yaml
podman kube down kube.yaml
```
---

## React + backend stacks

### `react-express-mongodb`

Pod: `mongo`, `backend` (Node), `frontend` (React dev) on host `3000`.

```bash
cd react-express-mongodb
podman build -t react-express-mongodb-backend backend
podman build -t react-express-mongodb-frontend frontend
podman kube play kube.yaml
podman kube down kube.yaml
```
### `react-express-mysql`

Pod: `db` (MariaDB), `backend` (Node, ports `80`, `9229`, `9230`), `frontend` (React/nginx) on host `3000`.

```bash
cd react-express-mysql
podman build -t react-express-mysql-backend backend
podman build -t react-express-mysql-frontend frontend
podman kube play kube.yaml
podman kube down kube.yaml
```
### `react-java-mysql`

Pod: `db` (MariaDB), `backend` (Spring Boot on `8080`), `frontend` (React/nginx) on host `3000`.

```bash
cd react-java-mysql
podman build -t react-java-mysql-backend backend
podman build -t react-java-mysql-frontend frontend
podman kube play kube.yaml
podman kube down kube.yaml
```
### `react-rust-postgres`

Pod: `db` (Postgres, host `5432`), `backend` (Rust, `8000`), `frontend` (React/nginx, host `3000`).

```bash
cd react-rust-postgres
podman build -t react-rust-postgres-backend backend
podman build -t react-rust-postgres-frontend frontend
podman kube play kube.yaml
podman kube down kube.yaml
```
---

## Nextcloud + Redis + MariaDB

(already above as `nextcloud-redis-mariadb`)

---

## Pi-hole + cloudflared

### `pihole-cloudflared-DoH`

Pod: `cloudflared` (DoH on `5054`), `pihole` (DNS + web on host `53/67/8080/8443`).

```bash
cd pihole-cloudflared-DoH
# Adjust env values in kube.yaml to match your .env (TZ, WEBPASSWORD, etc.)
podman kube play kube.yaml
podman kube down kube.yaml
```
You may want to point the `hostPath` volumes to your actual pihole config locations if they differ from `/etc/pihole` and `/etc/dnsmasq.d`.

---

## WasmEdge samples

### `wasmedge-kafka-mysql`

Pod: `redpanda`, `etl` (Wasm microservice), `db` (MariaDB).

```bash
cd wasmedge-kafka-mysql
podman build -t etl-kafka etl
podman kube play kube.yaml
podman kube down kube.yaml
```
### `wasmedge-mysql-nginx`

Pod: `db` (MariaDB), `backend` (demo-microservice on `8080`), `frontend` (nginx static on host `8090`).

```bash
cd wasmedge-mysql-nginx
podman build -t demo-microservice backend
podman kube play kube.yaml
podman kube down kube.yaml
```
---

## Summary

- Every directory under the project root that had a `compose.yaml` but no `kube.yaml` now has a single-Pod manifest following the patterns from your existing examples.
- Host ports match the original Compose mappings.
- DB/storage components use `emptyDir` or simple `hostPath` for dev-style persistence, consistent with similar samples.
- HTTP-facing containers have `livenessProbe` configured where it’s straightforward (root or health-check endpoints).

If you’d like, next I can do a quick structural sanity pass (e.g. `podman kube play --dry-run` equivalents where possible) or tweak any specific sample (for persistence, Secrets instead of inline passwords, etc.).
