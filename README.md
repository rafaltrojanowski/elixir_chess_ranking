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
mix sac_sac_mate.import_players
```

## Admin

Visit: http://localhost:4000/players

## Status
- [x] Players import from FIDE (Standard, Rapid, Blitz)

### Admin Interface
- [x] Create / Update / Delete Players

## TODO

- [ ] fix tests
- [ ] rename ranking -> rating
- [ ] do not create new player if already exist (rating import)
- [ ] support all 3 types of ratings (import)
- [ ] save date in rating model
- [ ] allow to import from collection of XML files

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
