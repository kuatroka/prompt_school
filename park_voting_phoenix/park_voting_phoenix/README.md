# ParkVotingPhoenix

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix

## Seeding the Database

To seed the database with park data:

```bash
mix run priv/repo/seeds.exs
```

## Testing

### Elixir Tests

```bash
mix test
```

### End-to-End Tests with Playwright

Install dependencies:

```bash
bun install
bunx playwright install
```

Run E2E tests:

```bash
bunx playwright test
```
