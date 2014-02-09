Intercom User Search
=====================

This is a Rails 4 application iframing [Intercom.io](http://www.intercom.io) and providing a _working_ users search on top of it.

![Capture](ca
pture.png)

Dependencies
------------

```ruby
gem 'intercom'
gem 'algoliasearch-rails'
gem 'hogan_assets'
```

Installation
--------------

* ```git clone https://github.com/algolia/algoliasearch-rails-example.git```
*  ```bundle install```
*  Create your ```config/application.yml``` based on ```config/application.example.yml``` with your [Algolia](http://www.algolia.com) and [Intercom](http://www.intercom.io) credentials
*  ```bundle exec rails server```
*  Enjoy your ```http://localhost:3000``` examples!
