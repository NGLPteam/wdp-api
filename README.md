# WDP-API

## Setting up locally

[Docker](https://www.docker.com/get-started) must be installed in order to run the project locally. To start the project:

```bash
docker-compose up -d
```

The initial build can take a moment. Once it's all running:

```bash
docker-compose exec web bin/rake db:create
docker-compose exec web bin/rake db:migrate
```

That should get you up and running. You can run `bin/console` to access a rails console running in the `web` container.

### Installing / Upgrading gems

We use a special docker entrypoint.sh that allows us to bypass having to rebuild images when changing gems, it runs on
container boot, so after changing your Gemfile, run the following:

```bash
docker-compose restart web worker
```

The same applies as well if you change any code in initializers (as per normal Rails usage).

### Running migrations

```bash
docker-compose exec web bin/rake db:migrate
```

### Running tests

```bash
docker-compose exec web bin/rspec

# Running a specific test

docker-compose exec web bin/rspec spec/requests/graphql/mutations/create_item_spec.rb
```

If you have changed the database (new migrations, etc), run the following first:

```bash
docker-compose exec web bin/rake db:test:prepare
```

### Linting

Linting does not have to happen in Docker, since it is just a file analysis tool.

```bash
bin/rubocop

# But you can run it in docker if you don't have ruby installed locally

docker-compose exec web bin/rubocop
```

## Seeding with sample data

In a Rails console (`bin/console` locally, or `heroku run rails console` on staging):

This will eventually be better-automated, but for now

```ruby
# One-time, as-needed tasks. These are idempotent and can be run repeatedly safely.
Roles::Sync.new.call
Schemas::Static::LoadDefinitions.new.call

# Additive tasks:

# One time, or to add even more contributors:
Testing::ScaffoldContributors.new.call

# Scaffolds roles, communities (10 by default), each with randomized collections & items
# and test users (500 by default).
Testing::ScaffoldSystem.new.call
```
