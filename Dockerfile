ARG ALPINE_VERSION=3.8

FROM bitwalker/alpine-elixir:1.7.3 AS builder

ENV MIX_ENV=prod

WORKDIR /app

COPY . .

RUN bin/release

FROM alpine:${ALPINE_VERSION}

ENV MIX_ENV=prod

WORKDIR /app

COPY --from=release /app/_build/artifacts .

ENTRYPOINT ["bin/educator_aaa"]
HEALTHCHECK --start-period=5s CMD bin/educator_aaa ping
CMD ["foreground"]
