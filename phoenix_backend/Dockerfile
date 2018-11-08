FROM elixir:1.7-alpine as builder
RUN apk add git
RUN mix local.hex --force && mix local.rebar --force
WORKDIR /app
COPY . /app
RUN mix deps.get
RUN MIX_ENV=prod mix release --no-tar

FROM alpine:latest
RUN apk add bash openssl
WORKDIR /app
COPY --from=builder /app/_build/prod/rel/phoenix_backend/ .
CMD bin/phoenix_backend foreground
ENV PORT 80
EXPOSE $PORT
