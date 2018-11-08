# Spandex Example Projects

The purpose of this repo is to demonstrate how to integrate Spandex into a
variety of application scenarios you might see in real life. It also gives us a
way to easily validate that the right trace and span data is getting sent to
the supported back-ends.

For your convenience, we've created named branches that allow you to easily see
what's needed to use Spandex to [add tracing to a `Plug.Router`] or [add
tracing to a `Phoenix.Endpoint`] so that you can get started quickly with
tracing your own projects.

[add tracing to a `Phoenix.Endpoint`]: https://github.com/spandex-project/spandex_example/compare/base...trace_backend
[add tracing to a `Plug.Router`]: https://github.com/spandex-project/spandex_example/compare/base...trace_gateway

## Getting Started with This Example Repo

To get you started quickly if you want to try running the examples in this
repo, we've arranged the example projects using docker-compose.  We run all of
the following in a self-contained environment, so all you need to have
installed is Docker and Docker Compose.

* A Cowboy- and Plug-based API gateway service (just to show distributed tracing)
* A Phoenix-based database-backed application (to show Phoenix and Ecto integration)
* A Postgres database
* A Datadog agent to collect traces and forward them to Datadog APM

First, you'll need to set your API key:

```bash
cp datadog.env.example datadog.env

# Modify datadog.env to specify your API key
```

Then, run all the things:

```bash
docker-compose build
docker-compose up -d
```

You'll be able to hit the `gateway` service from your development machine at
http://localhost:4000 and the `backend` service at http://localhost:4001.
