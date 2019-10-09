# CavEat API

This Rails application is an API made to support the CavEat iOS app.

## Requirements
- Ruby 2.6.5
- Rails 5.2.3
- PostgreSQL

## Running Development Environment
```
bundle install
rails db:setup
rails server
```

## Running Tests
```
bundle install
rubocop
haml-lint app/views/
brakeman
rails db:setup
rails test
```
