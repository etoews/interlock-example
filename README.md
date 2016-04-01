Rough instructions on how to use this half-baked example.

```bash
script/deploy.sh
docker-compose up -d

open http://$(docker port interlockexample_lb1 80)
open http://$(docker port interlockexample_lb2 80)

docker-compose scale service1=3
docker-compose scale service2=5
```
