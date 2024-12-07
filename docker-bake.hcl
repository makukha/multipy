variable "IMG" { default = "makukha/multipython" }
variable "RELEASE" { default = "2024.12.7" }

variable "DEBIAN_DIGEST" { default = "sha256:4d63ef53faef7bd35c92fbefb1e9e2e7b6777e3cbec6c34f640e96b925e430eb" }
variable "PYENV_VERSION" { default = "2.4.21" }
variable "PYENV_SHA256" { default = "0aea2e748d7dd4b92f8addf859b16852db5a46e809c4941861b7f05aeaf61bfd" }

variable "PY" {
  default = {
    py27 = "2.7.18"
    py35 = "3.5.10"
    py36 = "3.6.15"
    py37 = "3.7.17"
    py38 = "3.8.20"
    py39 = "3.9.21"
    py310 = "3.10.16"
    py311 = "3.11.11"
    py312 = "3.12.8"
    py313 = "3.13.1"
    py314 = "3.14.0a2"
    # free threaded
    py313t = "3.13.1t"
    py314t = "3.14.0a2t"
  }
}


# --- build

group "default" {
  targets = ["pyenv", "py", "final"]
}

target "base" {
  args = {
    DEBIAN_DIGEST = DEBIAN_DIGEST
    PYENV_VERSION = PYENV_VERSION
    PYENV_SHA256 = PYENV_SHA256
  }
  platforms = ["linux/amd64"]
}

target "pyenv" {
  inherits = ["base"]
  target = "pyenv"
  tags = [
    "${IMG}:pyenv",
    "${IMG}:pyenv-${RELEASE}",
  ]
}

target "py" {
  inherits = ["base"]
  args = PY
  matrix = {
    TAG = keys(PY)
  }
  name = TAG
  target = TAG
  tags = [
    "${IMG}:${TAG}",
    "${IMG}:${TAG}-${RELEASE}",
  ]
}

target "final" {
  inherits = ["base"]
  args = PY
  target = "final"
  tags = [
    "${IMG}:latest",
    "${IMG}:${RELEASE}",
  ]
}


# --- test

group "test" {
  targets = [
    "test-base",
    "test-final",
    "test-readme",
    "test-tox",
  ]
}

target "test-base" {
  target = "test-base"
  args = { RELEASE = RELEASE }
  context = "tests"
  output = ["type=cacheonly"]
}

target "test-final" {
  target = "test-final"
  args = { RELEASE = RELEASE }
  context = "tests"
  output = ["type=cacheonly"]
}

target "test-readme" {
  args = { RELEASE = RELEASE }
  context = "tests"
  matrix = {
    TARGET = [
      "test-readme-basic",
      "test-readme-advanced",
    ]
  }
  name = TARGET
  output = ["type=cacheonly"]
  target = TARGET
}

target "test-tox" {
  args = { RELEASE = RELEASE }
  context = "tests"
  matrix = {
    TARGET = [
      "test-tox-36",
      "test-tox-37",
      "test-tox-38",
    ]
  }
  name = TARGET
  output = ["type=cacheonly"]
  target = TARGET
}
