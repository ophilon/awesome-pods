# Contributing

Contributions should be made via pull requests. Pull requests will be reviewed by one or more maintainers and merged when acceptable.

The goal of the **Awesome pods** is to provide a curated list of application samples that can be easily deployed with [podman kube play](https://docs.podman.io/en/latest/markdown/podman-kube.1.html).

## Two ways migrate from compose.yaml to kube.yaml

This project started as fork of [Docker Compose](https://github.com/docker/compose). Authors did a great job, original code saved in the **compose** branch - you can check it out any time. However, all compose.yaml configs kept and sometimes will work correctly with `podman-compose` command. The status of [podman-compose project](https://github.com/containers/podman-compose) well explained by [Matthew Heon](https://www.redhat.com/en/blog/podman-compose-docker-compose). The power of podman it's compatibility with some k8s API's, which allows smooth migration to kubernetes. So, let's start accustom yourself to brave new world of kuber.

### 1. Create pod and add containers via podman commands:

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
$ podman run -d --pod=wpod --env-file .env.wp --name=web docker.io/library/wordpress:latest
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
$ podman volume rm wpod-db-data wpod-web-data
```

7. run podman kube play kube.yaml

```
$ podman kube play kube.yaml
```

### 2. Create new kube.yaml from below template

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
