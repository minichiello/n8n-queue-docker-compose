# Creating n8n with queues using docker compose

## Environment variables:

```
REDIS_PASSWORD=redispassword123
```

## Directories
```
mkdir n8n_storage postgres_data redis_data traefik_data

sudo chown -R 1000:1000 ./n8n_storage
sudo chown -R 999:999 ./postgres_data
sudo chown -R 999:999 ./redis_data
sudo chown -R 1000:1000 ./traefik_data

sudo chmod -R 750 n8n_storage postgres_data redis_data traefik_data

ls -ld n8n_storage
ls -ld redis_data
ls -ld postgres_data
ls -ld traefik_data

```

## Commands
```
sudo docker compose up -d
sudo docker compose stop
```

## Notes
n8n recommends using Postgres 13+. Running n8n with execution mode set to queue with an SQLite database isn't recommended.