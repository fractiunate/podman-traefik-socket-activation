## Build Dockerfile

```bash
podman build -t nginx-idle examples/nginx-autoshutdown/
podman run -p 8080:80 -d --name nidle nginx-idle 
docker exec -it c39 sh
d rm c39 -f
```


Copy container to socket/ systemd config: 

```
cp podman-traefik-socket-activation-web/examples/nginx-autoshutdown/*.container \
   ~/.config/containers/systemd/
cp podman-traefik-socket-activation-web/examples/nginx-autoshutdown/*.service \
   ~/.config/systemd/user/
cp podman-traefik-socket-activation-web/examples/nginx-autoshutdown/*.socket \
      ~/.config/systemd/user/
```