# Chess Ranking (Scraper) 

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

## Debugging

```
require IEx; IEx.pry
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
mix sac_sac_mate.import_ratings # populate `ratings` table based on XML data (~ 8 hours, 18800465 records) (*)
mix sac_sac_mate.create_players # populate `players` table based on `ratings` table (create associations)

mix sac_sac_mate.stats # print info about data in database
```

* NOTE: Currently `import_ratings` task stores only top 100 players.

## Admin

Visit: http://localhost:4000/ratings
Visit: http://localhost:4000/players

## Importing local database to Heroku

```
pg_dump -Fc --no-acl --no-owner -h localhost -U username sac_sac_mate_dev > sac_sac_mate_latest.dump
```

Simply run:

```
heroku pg:backups:restore 'https://sac-sac-mate.s3.eu-west-2.amazonaws.com/sac_sac_mate_latest.dump' DATABASE_URL --app sac-sac-mate
```

Note: Remember to grant public read access to the object while you upload your file to S3.

## Status
- [x] Import Players with rankings from FIDE (Standard, Rapid, Blitz)

### Admin Interface
- [x] Create / Update / Delete Players
- [x] Create / Update / Delete Rankings

### API
- [ ] Add endpoints

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
