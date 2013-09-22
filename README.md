# Prairie

[![Build Status](https://travis-ci.org/garyf/prairie.png?branch=master)](https://travis-ci.org/garyf/prairie)
[![Code Climate](https://codeclimate.com/github/garyf/prairie.png)](https://codeclimate.com/github/garyf/prairie)

Prairie is a Rails 4.0 app that demonstrates the use of the [Redis](http://redis.io/) key value store
to implement dynamic custom fields. Prairie relies on the [redis-objects](https://github.com/nateware/redis-objects)
gem for much of the interaction with Redis. Its architecture addresses potential situations
where a user might want to create dozens, or perhaps hundreds, of custom fields.

## Features

- **Redis configuration:** defined locally within config/
- **Custom field grouping and sequencing:** within groups, custom fields are sequenced using the Ranked-Model gem
- **Custom field validation** including string length and numerical limits
- **Test coverage:** full Rspec coverage and reporting with the Simplecov gem
- **Pagination:** using the Kaminari gem
- **Decorators:** using the Active Decorator gem
- **Styling:** with Twitter Bootstrap

## Setup

Prairie requires PostgreSQL and Redis. With Ruby 1.9.3 or later and gem bundler installed:

```bash
bundle install
bundle exec rake db:create:all
bundle exec rake db:migrate
redis-server ./config/redis/dvlp_6379.conf
rails s
```

### Redis configuration

See dvlp_9212.conf or test_6379.conf

## Why 'Prairie'

A prairie suggests an expanse of meadows, full of diverse fields and wildlife.
