Rough instructions on how to use this half-baked example.

Terminal 1

```bash
script/deploy.sh
```

Terminal 2

```bash
docker-compose up
```

Note the errors.

Terminal 3

```bash
source script/include/constants.sh
source script/include/util.sh
output_nginx_config
```

The `upstream` and `server` are not right.
