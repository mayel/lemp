# wordpress

> https://wordpress.org

## Development

```bash
$ git clone https://git.autonomic.zone/autonomic-cooperative/wordpress && cd wordpress
$ python3 -m venv .venv && source .venv/bin/activate
$ pip install -r requirements.txt
$ docker-compose up
```

Then visit the new Wordpress site.

> http://localhost:8010

On the first run, you'll have to wait some seconds for the database to
initialise before running through the initial installation. We don't make use
of something like [wait-for-it](https://github.com/vishnubob/wait-for-it)
because the `depends_on` stanza makes Docker swarm wait for it to come up on
the production deploy. So, we can just avoid doing this altogether for the
development workflow to save ourselves work.
