FROM elixir:1.10-alpine as builder
RUN mix local.hex --force && mix local.rebar --force
WORKDIR /app
COPY . /app
RUN apk add git
RUN mix deps.get
RUN MIX_ENV=prod mix release

FROM alpine:3.11
RUN apk add bash openssl
WORKDIR /app
COPY --from=builder /app/_build/prod/rel/plug_gateway/ .
CMD bin/plug_gateway foreground
ENV PORT 80
EXPOSE $PORT
