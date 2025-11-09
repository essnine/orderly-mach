FROM alpine:latest

RUN mkdir /root/app

WORKDIR /root/app

COPY . .

RUN apk add janet janet-dev git musl

RUN git clone https://github.com/janet-lang/jpm jpm && cd jpm && PREFIX=/usr janet bootstrap.janet
RUN PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 jpm -l deps
RUN jpm -l build && chmod +x build/orderly-mach

EXPOSE 80

ENTRYPOINT [ ]

CMD [ "build/orderly-mach" ]
