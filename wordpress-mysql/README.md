## WordPress with MySQL
This example defines one of the basic setups for WordPress. More details on how this works can be found on the official [WordPress image page](https://hub.docker.com/_/wordpress).


Project structure:
```
.
├── compose.yaml
├── kube.yaml
└── README.md
```

[_kube.yaml_](kube.yaml)
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

When deploying this setup, podman maps the WordPress container port 80 to
port 8080 of the host as specified in the compose file.

> ℹ️ **_INFO_**  
> For compatibility purpose between `AMD64` and `ARM64` architecture, we use a MariaDB as database instead of MySQL.  
> You still can use the MySQL image by uncommenting the following line in the Compose file   
> `#image: mysql:8.0.27`

## Deploy with podman

```
$ podman kube play kube.yaml
$ podman ps -ap
CONTAINER ID  IMAGE                               COMMAND               CREATED         STATUS         PORTS                 NAMES               POD ID        PODNAME
843b257ea988  localhost/podman-pause:4.9.3-0                            18 seconds ago  Up 15 seconds  0.0.0.0:8080->80/tcp  ae8541531313-infra  ae8541531313  wpod
fc3578afbc60  docker.io/library/mariadb:latest    mariadbd              16 seconds ago  Up 15 seconds  0.0.0.0:8080->80/tcp  wpod-db             ae8541531313  wpod
c5419ad8f275  docker.io/library/wordpress:latest  apache2-foregroun...  15 seconds ago  Up 15 seconds  0.0.0.0:8080->80/tcp  wpod-web            ae8541531313  wpod
```

## Expected result

Check containers are running and application works as expected:
```
$ curl -I localhost:8080
HTTP/1.1 200 OK
Date: Wed, 26 Mar 2025 07:10:09 GMT
Server: Apache/2.4.62 (Debian)
X-Powered-By: PHP/8.2.28
Link: <http://localhost:8080/index.php?rest_route=/>; rel="https://api.w.org/"
Content-Type: text/html; charset=UTF-8
```

Navigate to `http://localhost:8080` in your web browser to access WordPress.

![page](output.jpg)

Stop and remove the pod and containers

```
$ podman pod stop wpod
$ podman pod rm wpod
```

WordPress data use persistent volumes inside your HOME folder, you may work with it usual way: backup, restore or remove. Here some commands to help your work done:
```
$ podman volume ls
DRIVER      VOLUME NAME
local       data
local       web
$ podman volume inspect data web --format '{{json .Mountpoint}}'
"/home/ophil/.local/share/containers/storage/volumes/data/_data"
"/home/ophil/.local/share/containers/storage/volumes/web/_data"
$ ls -l ~/.local/share/containers/storage/volumes/
total 18
drwx------ 3 ophil ophil 3 Mar 26 09:34 data
drwx------ 3 ophil ophil 3 Mar 26 09:34 web
$ podman volume rm data web
data
web
```
