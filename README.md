Rough instructions on how to use this example.

```bash
script/deploy.sh
docker-compose up -d

open http://$(docker port interlockexample_lb1 80)
open http://$(docker port interlockexample_lb2 80)

docker exec interlockexample_lb1 cat /etc/nginx/nginx.conf
docker exec interlockexample_lb2 cat /etc/nginx/nginx.conf

curl -s http://$(docker port interlockexample_lb1 80) | grep strong
curl -s http://$(docker port interlockexample_lb2 80) | grep strong

docker-compose scale service1=3
docker-compose scale service2=5
```
