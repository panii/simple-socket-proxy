FROM erlang:23.3-alpine
WORKDIR /usr/src/myapp
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' > /etc/timezone
COPY proxy .
ENTRYPOINT ["/usr/local/bin/escript", "proxy"]
