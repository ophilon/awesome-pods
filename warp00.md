# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository overview

This repository is a curated collection of example application stacks packaged as Podman pods (and originally derived from docker/awesome-compose). Each subdirectory at the root (for example, `nginx-golang`, `react-express-mongodb`, `django`, `wordpress-mysql`) is a self-contained sample that can be run independently.

Samples are grouped in the top-level `README.md` into three categories:
- Multi-service applications with multiple integrated services (e.g., React + backend + database, NGINX + app + database, Elastic stack).
- Single-service samples (e.g., individual frameworks like Django, Flask, Angular, Traefik).
- Basic non-production setups for common self-hosted services (e.g., Gitea, Nextcloud, WordPress).

There is no shared application code or shared build system across samples; each directory is effectively its own small project.

## Directory structure and common patterns

At the root of each sample directory you will typically find:
- `compose.yaml`: the canonical Docker Compose definition for the stack.
- `README.md`: instructions and background specific to that stack.
- Optional `kube.yaml`: a Podman/kubernetes pod manifest for running the sample via `podman kube play` (present for some samples such as `angular`, `apache-php`, `flask`, `flask-redis`, `gitea-postgres`, `traefik-golang`, `wordpress-mysql`).
- One or more service directories such as `backend`, `frontend`, `app`, `nginx`, `proxy`, etc., each of which usually contains a `Dockerfile` and the service’s source code.

Important implications for Warp:
- Treat each sample directory as isolated; do not assume cross-directory imports or shared libraries.
- When a user refers to “the app,” clarify which sample directory they’re working in.
- When adding or modifying a sample, ensure its own `README.md`, `compose.yaml`, and (if applicable) `kube.yaml` remain self-consistent.

## Running samples with Podman and Kubernetes manifests

The primary workflow this repo promotes is running samples as Podman pods using kube manifests:

From within a sample directory that has a `kube.yaml`:

```bash
podman kube play kube.yaml
podman ps -ap           # inspect pod and containers
```

To tear down the sample:

```bash
podman kube down kube.yaml
```

Notes:
- Only some samples currently include `kube.yaml`; for others, use Docker Compose (see below) or follow the migration approaches in `CONTRIBUTING.md` to generate a manifest.
- For Podman Desktop users on macOS/Windows, the same `kube.yaml` can be used via the Podman Desktop UI or `podman kube` CLI.

## Running samples with Docker Compose

Every sample directory has a `compose.yaml` describing the services, networks, and volumes. The typical workflow (documented in each sample’s `README.md`) is:

From within a sample directory:

```bash
# Start the stack in the background
docker compose up -d

# Inspect running services
docker compose ps

# View logs (all services)
docker compose logs -f

# Stop and remove containers
docker compose down
```

Some samples add small conveniences on top of this. For example, in `nginx-golang/Makefile`:
- `make up` → `docker compose up -d`.
- `make down` → `docker compose down`.
- `make logs` → follow logs.
- `make test` → simple curl-based health check against `http://localhost:80`.

When working in a specific sample, prefer its Makefile/README shortcuts if present, otherwise fall back to the generic `docker compose` commands above.

## Podman-first workflows and migration from compose.yaml

The `CONTRIBUTING.md` file describes three patterns for moving from Docker Compose to Podman `kube.yaml` manifests:

1. **Manual pod creation and export (e.g., `wordpress-mysql`):**
   - Move configuration from `compose.yaml` into `.env` files as needed.
   - Create a pod with `podman pod create ...` and add containers with `podman run --pod ...`.
   - Inspect with `podman ps -ap`.
   - Generate `kube.yaml` via `podman generate kube <podname> > kube.yaml`.

2. **Authoring directly from a kube template:**
   - Start from a generic Pod spec template (see `kube.template.yaml` example in `CONTRIBUTING.md`).
   - Fill in container images, ports, env vars, and volume mounts based on the existing `compose.yaml` and the sample’s `README.md`.

3. **Using the `podlet` tool:**
   - Copy a `compose.yaml` into a new `pod.yaml` and run `podlet compose --kube pod.yaml`.
   - Resolve any reported incompatibilities (e.g., missing `name`, unsupported `restart` or `expose` fields).
   - Re-run with output flags (e.g., `podlet -f . compose --kube pod.yaml`) to generate `*.kube` and `*-kube.yaml` files.
   - Validate with `podman kube play <generated>.yaml` and `podman ps -ap`.

When adding or updating a sample, prefer one of these workflows so that both `compose.yaml` and `kube.yaml` stay in sync.

## Sample-specific helper workflows

A few samples provide extra tooling for local workflows:

- `nginx-golang/Makefile` (Docker Compose–centric):
  - `make help` lists available targets.
  - `make up` / `make down` / `make restart` wrap `docker compose` lifecycle commands.
  - `make logs` tails logs; `make ps` and `make stats` wrap `docker compose ps` / `docker compose stats`.
  - `make test` runs a basic HTTP check against `http://localhost:80`.

- `traefik-golang/Makefile` (Podman + kube-centric):
  - Uses a `vshell`/`vhost`/`workdir` abstraction to allow running either locally or via SSH (`CONTAINER_HOST`). The baked-in `workdir` path may not match this clone; adjust as needed if you use these targets.
  - `make up` / `make down` run `envsubst < kube.yaml | podman kube play/down -` to manage the pod.
  - `make test` curls the configured host (default `localhost:8080`).
  - `make logs`, `make ps`, and `make stats` inspect pods via `podman pod logs`, `podman ps -ap`, and `podman stats`.

When a user asks to “start” or “restart” these particular samples, prefer the Makefile targets so that any environment substitutions and Podman/Kubernetes specifics are handled by existing scripts.

## Adding or modifying samples

Key points from `CONTRIBUTING.md` for Warp to keep in mind when automating changes:
- The core goal is to provide clear, runnable examples of applications that can be easily deployed with `podman kube play`.
- New or updated samples should:
  - Include a `README.md` explaining the application, its structure, and how to run it.
  - Include or update `compose.yaml` (and preferably `kube.yaml`) so the sample is runnable with both Docker Compose and Podman kube.
  - Be added to the global list in the root `README.md` under the appropriate category.
- If asked to “migrate” an existing compose-only sample, use one of the three documented migration methods rather than inventing an ad-hoc scheme.

## Testing and linting

This repository does **not** define any top-level build, lint, or test commands. Each sample uses the tooling standard to its stack (Go, Node.js, Python, Java, etc.), and many do not ship explicit test suites.

Guidance for Warp:
- Do not assume the existence of a global test runner; there is no `make test` or similar at the repo root.
- If a user requests tests for a specific sample, first inspect that sample’s directory for language-specific tooling (e.g., `go.mod`, `package.json`, `requirements.txt`, `pom.xml`) and add tests using the conventions of that ecosystem.
- When running tests, run them from within the relevant sample directory and keep them scoped to that stack.

## How Warp should interpret user requests

- Always clarify which sample directory a user is referring to before making code changes.
- Prefer to modify only the requested sample, unless the user explicitly wants cross-sample updates (for example, updating all `compose.yaml` files).
- When adding new examples, follow the patterns in existing samples and ensure documentation (`README.md`) and manifests (`compose.yaml`, `kube.yaml`) are kept in sync.

please, work on every folder one by one. let's start with django - take as example file traefik-golang/make_compose and change it to run all targets for the django app

super! now find every folder without make_compose and proceed the same way - create make_compose as you did for django projects
