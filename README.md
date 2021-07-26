# simple-socket-proxy

运行环境: erlang 18以上  
转发各类tcp消息，如mysql、redis、windows远程链接、ssh等  
使用方式一，正向转发  
命令 ./proxy -listen-left 33306 -connect-right 127.0.0.1:3306 -dump no 可以实现33306到3306的端口转发  
  
使用方式二，反向转发。先由内网连公网开启一个守护链接，从而通过公网连通内网部署的服务  
命令如下图:
```
%    +------------------------[ Company Network ]-------------------------+  
%    |                                                                    |  
%    |   <proxy -connect-left 127.0.0.1:22 -connect-right x.x.x.x:2222>   | <-------------------+  
%    |                                |                                   |                     |  
%    |                                |                                   |                     |  
%    |           +------------+       |                                   |                     |  
%    |           | ssh server | <-----+                                   |                     |  
%    |           +------------+                                           |                     |  
%    |                                                                    |                     |  
%    +------------------------[ Company Network ]-------------------------+                     |  
%                                                                                               |  
%                                                                                               |  
%                                                                                               |  
%   +----------[ Home ]----------+      +--------------[ Public Network ]---------------+       |  
%   |                            |      |                                               |       |  
%   |                            |      |                                               |       |  
%   | <ssh root@x.x.x.x -p 1222> | ---> | <proxy -listen-left 1222 -listen-right 2222>  | <-----+  
%   |                            |      |                                               |  
%   |                            |      |                                               |  
%   +----------[ Home ]----------+      +--------------[ Public Network ]---------------+  
```

2021年4月22日 update  
docker中执行  
```
cd simple-socket-proxy
git clone https://github.com/panii/simple-socket-proxy
sudo docker run -it --rm --name socket-proxy1 -dp 3000:3000 -v "$PWD":/usr/src/myapp -w /usr/src/myapp erlang:23.3-alpine escript proxy -listen-left 3000 -connect-right 192.168.3.73:22 -dump size
sudo docker logs -f socket-proxy1
sudo docker stop socket-proxy1
```

2021年7月26日 update  
编译了一个单独的docker image  
```
可以方便的这样用
sudo docker run panii/simple-socket-proxy --help
sudo docker run -d --net=host panii/simple-socket-proxy -listen-left 33306 -connect-right 192.168.3.73:3306 -dump str
```