
## Email

By default, our development environment sends emails to `localhost:1025`. We use [`mailcatcher`](http://mailcatcher.me/) to catch and display our emails.

```bash
gem install mailcatcher
mailcatcher
```

## Development

We want to simulate the production environment's subdomains (for passing cookies between ca-web and ca-socket), so add the following in your `/etc/hosts`:

```
127.0.0.1 www.ca.local
127.0.0.1 socket.ca.local
```

## Staging

Set up your staging environment using the following steps:

1. Create two Heroku apps, one for ca-web and one for ca-socket. Make sure the app names are identical except for "web" and "socket". (e.g. "ca-web-staging" and "ca-socket-staging")

2. `heroku config:set NODE_ENV=staging -a YOUR_CA_SOCKET_APP`

You're done! Note that since we cannot pass cookies between Heroku apps, ca-socket will accept any connection and generate a random email address. Therefore, you can't test functionality that requires ca-socket to know the user set on ca-web's cookie.

## Angular integration

All angular files are under `app/assets/javascripts/angular`.
