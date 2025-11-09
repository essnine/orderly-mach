FROM alpine:latest

RUN mkdir /root/app

WORKDIR /root/app

RUN mkdir /root/posts

COPY . .

RUN apk add make gcc janet-dev git musl-dev

RUN git clone https://github.com/janet-lang/jpm jpm && cd jpm && PREFIX=/usr janet bootstrap.janet
RUN PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 jpm -l deps
RUN jpm -l build && chmod +x build/orderly-mach

EXPOSE 80

ENTRYPOINT [ ]

ENV POSTSPATH=/root/POSTS

CMD [ "build/orderly-mach" ]
