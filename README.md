# simple-socket-proxy

2013年左右写的小工具，用来转发tcp消息，用了几年做内网服务的代理，一直很稳定。编译成docker后只需要一行命令。  
  
运行环境: erlang 17以上  
转发各类tcp消息，如mysql、redis、windows远程链接、ssh等  
模式一，正向代理：  
命令 proxy -listen-left 13306 -connect-right 192.168.1.222:3306 -dump no 可以实现13306到3306的端口转发  
上述命令是监听本机的 13306 端口，当收到tcp请求，就去建立与另一台机器 192.168.1.222 的 3306 端口的链接，并转发它们的数据包  
  
模式二，反向代理：  
先在公网运行命令监听两方端口，再从内网运行命令连到公网，这样可以开启一个守护链接。之后就可以通过连接公网，透传连到内网的服务了  
命令如下图:
```
%    +------------------------[ Company Network ]-----------------------------+  
%    |   Second Step:                                                         |  
%    |   <proxy -connect-left internel_ip:22 -connect-right public_ip:2222>   | <-------------------+  
%    |                                |                                       |                     |  
%    |                                |                                       |                     |  
%    |           +------------+       |                                       |                     |  
%    |           | ssh server | <-----+                                       |                     |  
%    |           +------------+                                               |                     |  
%    |                                                                        |                     |  
%    +------------------------[ Company Network ]-----------------------------+                     |  
%                                                                                                   |  
%                                                                                                   |  
%                                                                                                   |  
%   +----------[ Home ]----------+      +--------------[ Public Network ]---------------+           |  
%   |                            |      |                                               |           |  
%   | Third Step:                |      | First Step:                                   |           |  
%   | <ssh root@x.x.x.x -p 1222> | ---> | <proxy -listen-left 1222 -listen-right 2222>  | <---------+  
%   |                            |      |                                               |  
%   |                            |      |                                               |  
%   +----------[ Home ]----------+      +--------------[ Public Network ]---------------+  
```

2022年5月9日 update  
可以方便在docker中执行, 开放自己的13306端口, 数据包与172.19.133.87:3306端口进行转发
```
git clone git@github.com:panii/simple-socket-proxy.git
cd simple-socket-proxy
alias proxy='docker run -v /etc/timezone:/etc/timezone -v /etc/localtime:/etc/localtime -it -d --net=host -v "$PWD":/usr/src/myapp -w /usr/src/myapp erlang:23.3-alpine escript proxy'
sudo docker run -it --rm --name mysql_proxy -dp 13306:13306 -v "$PWD":/usr/src/myapp -w /usr/src/myapp erlang:23.3-alpine escript proxy -listen-left 13306 -connect-right 172.19.133.87:3306 -dump no
sudo docker logs -f mysql_proxy
sudo docker stop mysql_proxy
```

2021年7月26日 update  
编译了一个单独的docker image  
```
可以方便的这样用
sudo docker run panii/simple-socket-proxy --help
sudo docker run -d --net=host panii/simple-socket-proxy -listen-left 33306 -connect-right 192.168.3.73:3306 -dump str
sudo docker run -d --net=host --restart=always panii/simple-socket-proxy -connect-left 127.0.0.1:3389 -connect-right 120.55.171.141:23389 -dump no
```
