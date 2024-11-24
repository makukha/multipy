# multipython 🐳<sup>🐍<sup>🐍</sup></sup>

> Docker image with latest pyenv Python 2.7 to 3.14 for multi-version testing.

[![Docker Pulls](https://img.shields.io/docker/pulls/makukha/multipython)](https://hub.docker.com/r/makukha/multipython)

Python versions included:

* CPython 3.14.a2
* CPython 3.13.0 — from [official Python image](https://hub.docker.com/layers/library/python/3.13.0-slim-bookworm/images/sha256-257a268975211849698b1a2c8e120aa8cd6600cef4fec8e995e36ec4090a0db8?context=explore)
* CPython 3.12.7
* CPython 3.11.10
* CPython 3.10.15
* CPython 3.9.20
* CPython 3.8.20
* CPython 3.7.17
* CPython 3.6.15
* CPython 3.5.10
* CPython 2.7.18

All Python binaries are symlinked to `/usr/local/bin/pythonX.Y` for `X.Y` in `2.7,3.5-3.14`.

Other tools:

* [pyenv](https://github.com/pyenv/pyenv) — latest master as of image release date
* [tox](https://tox.wiki) 4.5.1.1 — the last version that supports virtualenv 20.21.1
* [virtualenv](https://virtualenv.pypa.io/en/latest/) 20.21.1 — the last version that supports Python versions below 3.6

# Usage

```shell
docker pull makukha/multipython
```

```ini
# tox.ini
[tox]
env_list = py{27,35,36,37,38,39,310,311,312,313,314}
skip_missing_interpreters = false
[testenv]
# ...deps and commands
```

```yaml
# compose.yaml
services:
  tests:
    image: makukha/multipython:latest
    command: tox run
    volumes:
      # ...bind mount sources and tox.ini
```

```shell
docker compose run tests
```

# Alternatives

## [divio/multi-python](https://github.com/divio/multi-python)

Apt CPython 3.7 to 3.12 from deadsnakes PPA.

## [dhermes/python-multi](https://github.com/dhermes/python-multi)

pyenv CPython 3.8 to 3.12, PyPy 3.10.
