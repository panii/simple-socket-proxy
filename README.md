# simple-socket-proxy
A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet.
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
