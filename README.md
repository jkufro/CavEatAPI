# CavEat API

This Rails application is an API made to support the CavEat iOS app.

## Requirements
- [git lfs](https://git-lfs.github.com/)
- Ruby 2.6.5
- Rails 5.2.3
- PostgreSQL

## Running Development Environment
```
bundle install
rails db:setup
rails server
```

## Populating The Database
This repository has a slimmed down version of the UDSA food dataset (~ 300 foods). If you want to populate the database with the full dataset, then download `All foods` [here](https://fdc.nal.usda.gov/download-datasets.html), and place all CSV files in `lib/data/full/*.csv`. The full import process takes a considerable amount of time (30 minutes on 2017 8gb Macbook Pro).

**WARNING: Running the populate script will first delete all records (except the User table)**

```bash
# this will import the full dataset in production, and the slim dataset in other environments
rails db:populate

# This will force import the full dataset when not in production
USE_FULL=true rails db:populate

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


