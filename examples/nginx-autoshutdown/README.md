## Build Dockerfile

```bash
podman build -t nginx-idle examples/nginx-autoshutdown/
podman run -p 8080:80 -d --name nidle nginx-idle 
docker exec -it c39 sh
d rm c39 -f
```