FROM alpine:latest

RUN mkdir /root/app

WORKDIR /root/app

RUN mkdir /root/posts

COPY . .

RUN apk update && apk add make gcc janet-dev git musl-dev ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*

# Copy Tailscale binaries from the tailscale image on Docker Hub.
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /root/app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /root/app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

RUN git clone https://github.com/janet-lang/jpm jpm && cd jpm && PREFIX=/usr janet bootstrap.janet
RUN PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 jpm -l deps

EXPOSE 80

ENTRYPOINT [ "jpm", "-l", "janet", "main.janet" ]

ENV POSTSPATH=/root/app/pages

RUN chmod +x /root/app/start.sh

CMD ["/root/app/start.sh"]
