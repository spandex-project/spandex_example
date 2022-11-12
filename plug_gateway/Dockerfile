FROM elixir:1.14-alpine as builder
WORKDIR /app

RUN apk add --no-cache --update build-base git

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV prod

COPY mix.exs /app
COPY mix.lock /app
COPY config /app
RUN mix deps.get
RUN mix deps.compile

COPY . /app
RUN mix release

FROM elixir:1.14-alpine
RUN apk add --no-cache --update bash openssl
WORKDIR /app
COPY --from=builder /app/_build/prod/rel/plug_gateway/ .
CMD bin/plug_gateway start
ENV PORT 80
EXPOSE $PORT
