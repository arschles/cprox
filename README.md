# cprox

A basic HTTP proxy and url shortener written in [Crystal](https://crystal-lang.org).

## Proxy API

### `GET /forward/:code`

Forwards to the URL that was registered with `:code`

### `POST /code/:code`

Register the URL `:url` with a given code. The code should be specified in the `POST` body with JSON:

```json
{
    "url": "some URL here"
}
```

### `DELETE /code/:code`

Delete the given `:code` from the registry.

## Installation and development

All you need is the Crystal toolchain to build and run this project. Go [here](https://crystal-lang.org/install/) to learn how to install the toolchain.

When you have it installed, pull down the dependencies:

```console
$ shards install
```

When that's done, run the app:

```console
$ crystal run
```
