# Agrégateur #SocioNoel

Petit script pour agréger les tweets avec le hashtag #SocioNoel pour décembre 2017.


## Utilisation

Prérequis: ruby, bundler

Remplir un .env avec des clés valides pour l’API Twitter.

```
TWITTER_CONSUMER_KEY=...
TWITTER_CONSUMER_SECRET=...
TWITTER_ACCESS_TOKEN=...
TWITTER_ACCESS_TOKEN_SECRET=...
```

Faire tourner le script

```
$ bundle
$ bundle exec ./aggregator.rb
$ bundle exec ./prettifier.rb
```

Le résultat est dans `tweets.json` et `tweets.md`.

Licence CC-0.
