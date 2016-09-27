[![logo](https://raw.githubusercontent.com/coeusite/docker-transmission/master/logo.png)](https://www.transmissionbt.com/)

# Transmission

Transmission docker container

# What is Transmission?

Transmission is a BitTorrent client which features a simple interface on top of
a cross-platform back-end.

# How to use this image

This Transmission container was built to automatically download a level1 host
filter (can be used with dperson/openvpn).

    sudo docker run -it --cap-add=NET_ADMIN --device /dev/net/tun --name vpn \
                --dns 8.8.4.4 --dns 8.8.8.8 --restart=always \
                -d dperson/openvpn-client ||
    sudo docker run -it --name bit --net=container:vpn \
                -d coeusite/docker-transmission
    sudo docker run -it --name web -p 80:80 -p 443:443 --link vpn:bit \
                -d dperson/nginx -w "http://bit:9091/transmission;/transmission"

**NOTE**: The default username/password are `admin`/`admin`. See `TRUSER` and
`TRGROUP` below, for how to change them.

## Hosting a Transmission instance

    sudo docker run -it --name transmission -p 9091:9091 -d coeusite/docker-transmission

OR set local storage:

    sudo docker run -it --name transmission -p 9091:9091 \
                -v /path/to/directory:/var/lib/transmission-daemon \
                -d coeusite/docker-transmission

**NOTE**: The configuration is in `/var/lib/transmission-daemon/info`, downloads
are in `/var/lib/transmission-daemon/downloads`, and partial downloads are in
`/var/lib/transmission-daemon/incomplete`.

## Configuration

    sudo docker run -it --rm coeusite/docker-transmission -h

    Usage: transmission.sh [-opt] [command]
    Options (fields in '[]' are optional, '<>' are required):
        -h          This help
        -n          No auth config; don't configure authentication at runtime
        -t ""       Configure timezone
                    possible arg: "[timezone]" - zoneinfo timezone for container

    The 'command' (if provided and valid) will be run instead of transmission

ENVIRONMENT VARIABLES (only available with `docker run`)

 * `TRUSER` - Set the username for transmission auth (default 'admin')
 * `TRPASSWD` - Set the password for transmission auth (default 'admin')
 * `TZ` - As above, configure the zoneinfo timezone, IE `EST5EDT`
 * `USERID` - Set the UID for the app user
 * `GROUPID` - Set the GID for the app user

Other environment variables beginning with `TR_` will edit the configuration
file accordingly:

 * `TR_MAX_PEERS_GLOBAL=400` will translate to `"max-peers-global": 400,`

## Examples

Any of the commands can be run at creation with `docker run` or later with
`docker exec -it transmission.sh` (as of version 1.3 of docker).

### Setting the Timezone

    sudo docker run -it --name transmission -d coeusite/docker-transmission -t EST5EDT

OR using `environment variables`

    sudo docker run -it --name transmission -e TZ=EST5EDT \
                -d coeusite/docker-transmission

Will get you the same settings as

    sudo docker run -it --name transmission -p 9091:9091 -d coeusite/docker-transmission
    sudo docker exec -it transmission transmission.sh -t EST5EDT \
                ls -AlF /etc/localtime
    sudo docker restart transmission

### Seedbox
Run this command for a seedbox:
```bash
sudo docker run -it --name transmission -p 127.0.0.1:9091:9091 \
            -p 51413:51413/tcp -p 51413:51413/udp \
            -v /path/to/directory:/var/lib/transmission-daemon \
            -e "TR_PEX_ENABLED=false" \
            -e "TR_LPD_ENABLED=false" \
            -e "TR_DHT_ENABLED=false" \
            -e "TRUSER=<Your Username for Auth>" \
            -e "TRPASSWD=<Your Passcode for Auth>" \
            -d coeusite/docker-transmission
```

Note that you can install [Transmission Web Control](https://github.com/ronggang/transmission-web-control) by following commands:

```bash
sudo docker exec transmission /root/install-tr-web-control.sh
```

# User Feedback

## Issues

If you have any problems with or questions about this image, please contact me
through a [GitHub issue](https://github.com/coeusite/docker-transmission/issues).
