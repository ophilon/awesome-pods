# Awesome Podman Pods [![Awesome](https://awesome.re/badge.svg)](https://awesome.re)

![logo](awesome-pods.jpg)

### A curated list of Podman Pods samples.

These samples provide a starting point for how to integrate different services using `kube.yaml` manifest and to manage their deployment with `podman kube play` or in any **kubernetes environment**.

> **Note**
> The following samples are intended for use in local development environments such as project setups, tinkering with software stacks, etc. These samples must not be deployed in production environments.

<!--lint disable awesome-toc-->
## Contents

- [Samples of Podman Pods applications with multiple integrated services](#samples-of-podman-pods-applications-with-multiple-integrated-services).
- [Single service samples](#single-service-samples).
- [Basic setups for different platforms (not production ready - useful for personal use)](#basic-setups-for-different-platforms-not-production-ready---useful-for-personal-use).
- [Getting started](#getting-started).

## Samples of Podman Pods applications with multiple integrated services

<a href="https://developers.redhat.com/articles/2023/12/06/unlock-webassembly-workloads-podman-macos-and-windows#"><img src="icon_wasm.svg" alt="Podman + wasm" height="30" align="top"/></a> Icon indicates Sample is compatible with [Podman+Wasm](https://developers.redhat.com/articles/2023/12/06/unlock-webassembly-workloads-podman-macos-and-windows#).

- [`ASP.NET / MS-SQL`](aspnet-mssql) - Sample ASP.NET core application
with MS SQL server database.
- [`Elasticsearch / Logstash / Kibana`](elasticsearch-logstash-kibana) - Sample Elasticsearch, Logstash, and Kibana stack.
- [`Go / NGINX / MySQL`](nginx-golang-mysql) - Sample Go application
with an Nginx proxy and a MySQL database.
- [`Go / NGINX / PostgreSQL`](nginx-golang-postgres) - Sample Go
application with an Nginx proxy and a PostgreSQL database.
- [`Java Spark / MySQL`](sparkjava-mysql) - Sample Java application and
a MySQL database.
- [`NGINX / ASP.NET / MySQL`](nginx-aspnet-mysql) - Sample Nginx reverse proxy with an C# backend using ASP.NET.
- [`NGINX / Flask / MongoDB`](nginx-flask-mongo) - Sample Python/Flask
application with Nginx proxy and a Mongo database.
- [`NGINX / Flask / MySQL`](nginx-flask-mysql) - Sample Python/Flask application with an Nginx proxy and a MySQL database.
- [`NGINX / Node.js / Redis`](nginx-nodejs-redis) - Sample Node.js application with Nginx proxy and a Redis database.
- [`NGINX / Go`](nginx-golang) - Sample Nginx proxy with a Go backend.
- [`NGINX / WSGI / Flask`](nginx-wsgi-flask) - Sample Nginx reverse proxy with a Flask backend using WSGI.
- [`PostgreSQL / pgAdmin`](postgresql-pgadmin) - Sample setup for postgreSQL database with pgAdmin web interface.
- [`Python / Flask / Redis`](flask-redis) - Sample Python/Flask and a Redis database.
- [`React / Spring / MySQL`](react-java-mysql) - Sample React
application with a Spring backend and a MySQL database.
- [`React / Express / MySQL`](react-express-mysql) - Sample React
application with a Node.js backend and a MySQL database.
- [`React / Express / MongoDB`](react-express-mongodb) - Sample React
application with a Node.js backend and a Mongo database.
- [`React / Rust / PostgreSQL`](react-rust-postgres) - Sample React
application with a Rust backend and a Postgres database.
- [`React / Nginx`](react-nginx) - Sample React application with Nginx.
- [`Spring / PostgreSQL`](spring-postgres) - Sample Java application
with Spring framework and a Postgres database.
- [`WasmEdge / MySQL / Nginx`](wasmedge-mysql-nginx) - Sample Wasm-based web application with a static HTML frontend, using a MySQL (MariaDB) database. The frontend connects to a Wasm microservice written in Rust, that runs using the WasmEdge runtime.&nbsp;<a href="wasmedge-mysql-nginx"><img src="icon_wasm.svg" alt="Compatible with Podman+wasm" height="30" align="top"/></a>
- [`WasmEdge / Kafka / MySQL`](wasmedge-kafka-mysql) - Sample Wasm-based microservice that subscribes to a Kafka (Redpanda) queue topic, and transforms and saves any incoming message into a MySQL (MariaDB) database.&nbsp;<a href="wasmedge-kafka-mysql"><img src="icon_wasm.svg" alt="Compatible with Podman+wasm" height="30" align="top"/></a>

## Single service samples

- [`Angular`](angular)
- [`Spark`](sparkjava)
- [`VueJS`](vuejs)
- [`Flask`](flask)
- [`PHP`](apache-php)
- [`Traefik`](traefik-golang)
- [`Django`](django)
- [`Minecraft server`](minecraft)
- [`Plex`](plex)
- [`Portainer`](portainer)
- [`Wireguard`](wireguard)
- [`FastAPI`](fastapi)

## Basic setups for different platforms (not production ready - useful for personal use)

- [`Gitea / PostgreSQL`](gitea-postgres)
- [`Nextcloud / PostgreSQL`](nextcloud-postgres)
- [`Nextcloud / Redis / MariaDB`](nextcloud-redis-mariadb)
- [`Pi-hole / cloudflared`](pihole-cloudflared-DoH) - Sample Pi-hole setup with use of DoH cloudflared service
- [`Prometheus / Grafana`](prometheus-grafana)
- [`Wordpress / MySQL`](wordpress-mysql)

<!--lint disable awesome-toc-->

## Getting started

These instructions will get you through the bootstrap phase of creating and
deploying samples of containerized applications with Podman Pods.

### Prerequisites

- Make sure that you have Podman or Podman Desktop installed
  - Windows or macOS:
    [Install Podman Desktop](https://podman-desktop.io/)
  - Linux: [Install Podman](https://podman.io/) and then
    [podman-compose](https://github.com/containers/podman-compose)
- Download some or all of the samples from this repository.

### Running a sample

The root directory of each sample contains the `compose.yaml` from [awesome-compose](https://github.com/docker/awesome-compose), and corresponding `kube.yaml` manifest. The latter file can be run in any numerous [kubernetes distributions](https://www.cncf.io/training/certification/software-conformance/) or within `podman pod`. All samples can be run in
a local environment by going into the root directory of each one and executing:

```console
podman kube play kube.yaml
podman ps -ap
```

Check the `README.md` of each sample to get more details on the structure and
what is the expected output.
To stop and remove all containers of the sample application run:

```console
podman kube down kube.yaml
```

## Contribute

We welcome examples that help people understand how to use Podman Pods for
common applications. Check the [Contribution Guide](CONTRIBUTING.md) for more details. 

<!--lint disable awesome-toc-->
