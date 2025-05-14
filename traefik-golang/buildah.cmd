cd $HOME/src/traefik-golang
buildah rm backend
buildah from --name backend scratch
CGO_ENABLED='0' go build -v -ldflags "-w -s" -o back main.go
buildah copy backend back /usr/local/bin/backend
buildah config --entrypoint '["/usr/local/bin/backend"]' backend
buildah commit backend backend:latest
