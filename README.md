# Caddy server with all Addons addons

[alpine:edge](https://hub.docker.com/_/alpine/) based docker image for [caddy server](https://caddyserver.com/). Includes all the caddy addons.

The difference between this and other caddy dockers is how the settings and other data volumes are mounted.  Instead of mounting the Caddyfile directly, this container mounts the entire folder and expects a Caddyfile inside the folder.  This allows for use of [import](https://caddyserver.com/docs/import) directive of the Caddyfile.

The following are exposed folders

* `/www` : The default site location. 
* `/config` : The location of Caddyfile.  Caddy will expect a file named `Caddyfile` in this folder or the contianer will not start.  *The container does not create this file automatically.* 
* `/log` : The default location of the log files.  If Caddyfile is used to setup logs, it is advisible to write to this folder.
* `/store` : This is the CADDYHOME folder, which is usually `$HOME\.caddy`.  Make sure this is private as any LetsEncrypt certificate will be stored here.

## Usage

First create a valid Caddyfile in the [config folder].  This is a requirement for the container to start.

```sh
docker run --rm --name caddy \
    -p [httpport]:80 \
    -p [httpsport]:443 \
    -v [www foler]:/www \
    -v [config folder]:/config \
    -v [log folder]:/log 
    -v [caddy home]:/store \
    zafayar/caddy-server
```

You can also create a docker volume to store the certs in the store folder.

Creata docker volume first:
```sh
$ docker volume create --name certs-vol
```

Run the container wit the name of the volume instead of a host folder,

```sh
docker run --rm --name caddy \
    -p [httpport]:80 \
    -p [httpsport]:443 \
    -v [www foler]:/www \
    -v [config folder]:/config \
    -v [log folder]:/log 
    -v certs-vol:/store \
    zafayar/caddy-server
```

