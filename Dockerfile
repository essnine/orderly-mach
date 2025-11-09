FROM alpine:latest

RUN mkdir /root/app

WORKDIR /root/app

RUN mkdir /root/posts

COPY . .

RUN apk add make gcc janet-dev git musl-dev

RUN git clone https://github.com/janet-lang/jpm jpm && cd jpm && PREFIX=/usr janet bootstrap.janet
RUN PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 jpm -l deps

EXPOSE 80

ENTRYPOINT [ "jpm", "-l", "janet", "main.janet" ]

ENV POSTSPATH=/root/posts

CMD [ "jpm", "-l", "janet", "main.janet" ]
