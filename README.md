# chatex

[![Build Status](https://travis-ci.org/KamilLelonek/chatex.svg?branch=master)](https://travis-ci.org/KamilLelonek/chatex)

## Installation

### Language & Libraries

First of all, make sure you have Elixir installed by covering the official [installation guide](https://elixir-lang.org/install.html) on your machine. Alternatively, you can use [`asdf`](https://github.com/asdf-vm/asdf) tool and leverage [`.tool-versions`](.tool-versions) file to pick the right version of [Elixir](https://github.com/asdf-vm/asdf-elixir) and [Erlang](https://github.com/asdf-vm/asdf-erlang) plugins.

Once you have it, you can install and compile all dependencies by running:

    mix do deps.get, deps.compile

Finally, you are able to build the project itself like:

    mix compile

### Database

Ensure you have `PostgreSQL` available on your machine. You can use either a [local installation](https://www.postgresql.org/download/) or a [Docker distribution](https://docs.docker.com/engine/examples/postgresql_service/).

The application requires to have a user (role) `postgres` created with the same password on your `localhost` under `5432` port.

Later on, create and migrate your database with

    mix ecto.setup

### Server

To start the application Phoenix server, run:

    mix phx.server

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Production

To prepare you application for production, you can use [`Dockerfile`](Dockerfile) for that. It will require you have [`Docker` installed locally](https://docs.docker.com/install/).

To build a `Docker` image, execute the following command:

    docker build . -t chatex:latest

Once built, you are able to push it to a remote repository as:

    docker push chatex:latest

It assumes you are authorized and logged in to a [`Docker` registry](https://docs.docker.com/registry/).

### Platform as a Service

From the deployment options, you can choose for example:

- [Heroku](https://devcenter.heroku.com/articles/container-registry-and-runtime)
- [Gigalixir](https://gigalixir.readthedocs.io/en/latest/main.html#deploy)
- [Google Cloud Platform](https://cloud.google.com/elixir/)
- [Render](https://render.com/docs/deploy-phoenix)

Depending on your needs and complexity of your application.
