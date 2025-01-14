# Maintainer Notes

## Check for updated dependencies

```shell
$ task checkupd
```

Images are expected to be updated in these cases:

* Update of base image `debian:stable-slim`.
* Patch update of `pyenv`, e.g. new Python version is released.
* Minor update of `pip`, `setuptools`, `tox`, `uv`.
* Critical bug is found in `multipython` or one of Python distributions.

In all these and other cases, all images are rebuilt from ground up.

## Initialize dev environment

```shell
$ task init
```

## Develop

```shell
$ task checkupd
$ task news:* -- Message — by @username
$ task build:*
$ task shell:* -- -v ...
$ task run:* -- ...
```
