# wordpress

> https://wordpress.org

> https://wp.swarm.autonomic.zone

## Development

```bash
$ git clone https://git.autonomic.zone/autonomic-cooperative/wordpress && cd wordpress
$ python3 -m venv .venv && source .venv/bin/activate
$ pip install -r requirements.txt
$ docker-compose up
```

Then visit the new Wordpress site.

> http://localhost:8010

## Production

1. Our [drone.autonomic.zone](https://drone.autonomic.zone/autonomic-cooperative/wordpress/) configuration automatically deploys.
1. For a manual deploy guide, see [this documentation](https://git.autonomic.zone/autonomic-cooperative/organising/wiki/working-with-docker-swarm).
