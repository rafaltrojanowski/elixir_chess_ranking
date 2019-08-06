# SacSacMate

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Tasks

```
mix sac_sac_mate.download_ratings # download XML files
mix sac_sac_mate.unzip_files # unzip all downloaded files
mix sac_sac_mate.import_ratings # populate `ratings` table based on XML data
mix sac_sac_mate.create_players # populate `players` table based on `ratings` table (create associations)
```

## Debugging

```
require IEx; IEx.pry
```

## Admin

Visit: http://localhost:4000/players

## Status
- [x] Players import from FIDE (Standard, Rapid, Blitz)

### Admin Interface
- [x] Create / Update / Delete Players

## TODO

- [ ] Move Player and Rating to schema context like here: 
https://github.com/beam-community/elixir-companies/blob/master/lib/companies/schema/user.ex

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
