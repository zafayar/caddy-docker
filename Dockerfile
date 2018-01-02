FROM alpine:latest
MAINTAINER zafayar <zafayar@hotmail.com> 
ENV CADDY_VERSION=v0.10.10 \
    CADDYPATH=/store
RUN apk --update upgrade \
    && apk add --no-cache --no-progress ca-certificates git \
    && apk add --no-cache --no-progress --virtual .build_tools curl \
    && curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
	"https://caddyserver.com/download/linux/amd64?plugins=dyndns,http.authz,http.awses,http.awslambda,http.cache,http.cgi,http.cors,http.datadog,http.expires,http.filemanager,http.filter,http.forwardproxy,http.git,http.gopkg,http.grpc,http.hugo,http.ipfilter,http.jekyll,http.jwt,http.locale,http.login,http.mailout,http.minify,http.nobots,http.prometheus,http.proxyprotocol,http.ratelimit,http.realip,http.reauth,http.restic,http.upload,http.webdav,tls.dns.route53&license=personal" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
    && chmod 0755 /usr/bin/caddy \
    && /usr/bin/caddy -version \
    && apk del --purge .build_tools \
    && mkdir /store \
    && mkdir /log \
    && mkdir /config \
    && mkdir /www \
    && rm -rf \
      /usr/share/doc \
      /usr/share/man \
      /tmp/* \
      /var/cache/apk/* 

VOLUME ["/www", "/config", "/log", "/store"]
EXPOSE 80 443
ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/config/Caddyfile", "--log", "/log/caddyserver.log", "--root","/www", "--agree"]
