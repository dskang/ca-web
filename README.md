
## Email

By default, our development environment sends emails to `localhost:1025`. We use [`mailcatcher`](http://mailcatcher.me/) to catch and display our emails.

```bash
gem install mailcatcher
mailcatcher
```

## Domains

We want to simulate the production environment's subdomains, so add the following in your `/etc/hosts`:

```
127.0.0.1 www.campusanonymous.local
127.0.0.1 socket.campusanonymous.local
```

## Angular integration

All angular files are under `app/assets/javascripts/angular`.
