
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

Develop using the domains above rather than `localhost`.

## Staging

Set up your staging environment using the following steps. We will assume the names `ca-web-staging` and `ca-socket-staging` for the ca-web app and ca-socket app, respectively. For your Heroku app names, make sure they're identical except for the words "web" and "socket".

```bash
# ca-web
heroku create ca-web-staging
heroku git:remote -a ca-web-staging -r staging
git push staging master

# ca-socket
heroku create ca-socket-staging
heroku git:remote -a ca-socket-staging -r staging
git push staging master
heroku config:set NODE_ENV=staging -a ca-socket-staging
```

You're done! Note that since we cannot pass cookies between Heroku apps, ca-socket will accept any connection and generate a random email address. Therefore, you can't test functionality that requires ca-socket to know the user set on ca-web's cookie.

## Angular integration

All angular files are under `app/assets/javascripts/angular`.
