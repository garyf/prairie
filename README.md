# Prairie

[![Build Status](https://travis-ci.org/garyf/prairie.png?branch=master)](https://travis-ci.org/garyf/prairie)
[![Code Climate](https://codeclimate.com/github/garyf/prairie.png)](https://codeclimate.com/github/garyf/prairie)
[![Coverage Status](https://coveralls.io/repos/garyf/prairie/badge.png?branch=master)](https://coveralls.io/r/garyf/prairie?branch=master)

Prairie is a Rails 4.0 app that demonstrates the use of the [Redis](http://redis.io/) key value store
to implement dynamic custom fields. Prairie relies on the [redis-objects](https://github.com/nateware/redis-objects)
gem for much of the interaction with Redis. Its architecture addresses potential situations
where a user might want to create dozens, or perhaps hundreds, of custom fields.

## Dynamic custom fields

- **Multiple field types** including string, numeric, select list, radio button and checkbox
- **Custom field grouping and sequencing:** within groups, custom fields are sequenced using the Ranked-Model gem
- **Custom field validation** including string length and numerical limits

## Search

What is the point of creating custom fields without the ability to search them? Prairie provides **by-relevance** search
that orders search results in 3 groups:

- **Exact match of all** search terms, including core and custom fields
- **Exact match of any** search term
- **Near match of all** search terms, with 'substring' matching of string fields and 'within range' matching of numeric fields

## Code quality

- **Test coverage:** full Rspec coverage and reporting with the Simplecov gem
- **Acceptance testing** features with the Capybara gem
- **Redis configuration** explicitly defined; see dvlp_9212.conf or test_6379.conf
- **Pagination:** with the Kaminari gem
- **Decorators:** with the Active Decorator gem
- **Global settings** with the Settingslogic gem
- **Styling:** with Twitter Bootstrap

## Setup

Prairie requires PostgreSQL and Redis. With Ruby 1.9.3 or later and gem bundler installed:

```bash
bundle install
bundle exec rake db:create:all
bundle exec rake db:migrate
redis-server ./config/redis/dvlp_9212.conf
rails s
```

## Why 'Prairie'

A prairie suggests an expanse of meadows, full of diverse fields and wildlife.
