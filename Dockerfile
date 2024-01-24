FROM erlang:23.3-alpine
WORKDIR /usr/src/myapp

RUN apk add --no-cache tzdata
ENV TZ=Asia/Shanghai

COPY proxy .
ENTRYPOINT ["/usr/local/bin/escript", "proxy"]
