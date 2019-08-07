# SacSacMate

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).


## Database setup

```
mix ecto.drop
mix ecto.create
mix ecto.migrate
```

## Running tests

```
mix test
iex -S mix test                         # if need debugger
iex -S mix test test/path/some_test.ex  # running specific test
```

## Tasks

```
mix sac_sac_mate.download_ratings # download XML files
mix sac_sac_mate.unzip_files # unzip all downloaded files
mix sac_sac_mate.import_ratings # populate `ratings` table based on XML data (~ 8 hours, records)
mix sac_sac_mate.create_players # populate `players` table based on `ratings` table (create associations)

mix sac_sac_mate.stats # print info about data in database
```

## Debugging

```
require IEx; IEx.pry
```

## Admin

Visit: http://localhost:4000/ratings
Visit: http://localhost:4000/players

## Heroku

https://sac-sac-mate.herokuapp.com

## Importing local database to Heroku

TODO:

## Status
- [x] Players import from FIDE (Standard, Rapid, Blitz)

### Admin Interface
- [x] Create / Update / Delete Players

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
