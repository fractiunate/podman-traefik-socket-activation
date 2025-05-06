# podman-traefik-socket-activation

This demo shows how to run a socket-activated traefik container with Podman.
See also the tutorials [Podman socket activation](https://github.com/containers/podman/blob/main/docs/tutorials/socket_activation.md) and
[podman-nginx-socket-activation](https://github.com/eriksjolund/podman-nginx-socket-activation).

Overview of the examples

| Example | Type of service | Ports | Using quadlet | rootful/rootless podman | Comment |
| --      | --              |   -- | --      | --   | --  |
| [Example 1](examples/example1) | systemd user service | 80, 443 | yes | rootless podman | |

### Advantages of using rootless Podman with socket activation

See https://github.com/eriksjolund/podman-nginx-socket-activation?tab=readme-ov-file#advantages-of-using-rootless-podman-with-socket-activation

### Discussion about SELinux

When using the traefik option __--providers.docker__, traefik needs access to a unix socket
that provides the Docker API. By default the path to the unix socket is  _/var/run/docker.sock_.
SELinux will by default block access to the file.

Currently, the problem is worked around by disabling SELinux for the traefik container.

The quadlet unit file contains this line:
```
SecurityLabelDisable=true
```

Another workaround could have been to bind-mount the unix socket with the `:z` option,
but that would change the file context of the unix socket which might cause problems for
other programs.

See also
https://bugzilla.redhat.com/show_bug.cgi?id=1495053#c2


## Ubuntu 22.04 Server Init

```bash
apt update
apt install podman jq systemd-container -y
alias docker=podman

# https://github.com/eriksjolund/podman-traefik-socket-activation/tree/main/examples/example1
apt-get install -y systemd-container # login with test user


docker run -d -p 8080:80 docker.io/library/nginx

systemctl enable podman.socket
systemctl start podman.socket
systemctl status podman.socket

# ufw allow from any to any port 8080 proto tcp

netstat -peanut


docker run -d -p 8080:8080 -p 80:80   -v $PWD/traefik.yml:/etc/traefik/traefik.yml   -v /run/user/1005/podman/podman.sock:/var/run/docker.sock docker.io/library/traefik:v3


## SOCKET COMMANDS
systemctl status whoami.service
systemctl --user stop whoami.service


## PODMAN COMMANDS
podman ps --format='{{json .Labels}}' #Show podman pod labels

```
