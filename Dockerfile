# hadolint global ignore=DL3008,DL4006
# DL3008 => apt pakage versions are not locked in this project
# DL4006 => -o pipefail is already set globally

ARG PYENV_ROOT=/root/.pyenv
ARG MULTIPYTHON_ROOT=/root/.multipython

# pyenv

FROM debian:stable-slim AS pyenv
SHELL ["/bin/bash", "-eux", "-o", "pipefail", "-c"]

RUN <<EOT
    apt-get update
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        jq \
        lcov \
        libbz2-dev \
        libffi-dev \
        libgdbm-compat-dev \
        libgdbm-dev \
        liblzma-dev \
        libncursesw5-dev \
        libreadline6-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        libxmlsec1-dev \
        llvm \
        lzma \
        lzma-dev \
        pkg-config \
        tk-dev \
        uuid-dev \
        wget \
        xz-utils \
        zlib1g-dev
    rm -rf /var/lib/apt/lists/*
EOT

ARG PYENV_VERSION
ARG PYENV_SHA256
ARG PYENV_ROOT
# hadolint ignore=DL3003
RUN <<EOT
    wget -q "https://github.com/pyenv/pyenv/archive/refs/tags/v${PYENV_VERSION}.tar.gz" -O /tmp/pyenv.tar.gz
    echo "${PYENV_SHA256} /tmp/pyenv.tar.gz" | sha256sum --check --strict
    mkdir -p ${PYENV_ROOT}
    tar -xzf /tmp/pyenv.tar.gz -C ${PYENV_ROOT} --strip-components=1
    cd ${PYENV_ROOT} && src/configure && make -C src
    rm -rf /tmp/* /var/tmp/*
EOT

COPY --chmod=755 py.sh /usr/local/bin/py
COPY --chmod=755 py_checkupd.sh /usr/local/bin/py_checkupd

ARG BASE_DIGEST
ARG MULTIPYTHON_ROOT
COPY <<EOF ${MULTIPYTHON_ROOT}/deps
MULTIPYTHON_BASE_DIGEST="${BASE_DIGEST}"
EOF

ENV PATH="$MULTIPYTHON_ROOT/sys:$PYENV_ROOT/bin:$PATH"
ENTRYPOINT []
CMD ["/bin/bash"]


# single versions

FROM pyenv AS py27
ARG py27
RUN pyenv install ${py27}; py --link-pyenv; py --link-sys py27

FROM pyenv AS py35
ARG py35
RUN pyenv install ${py35}; py --link-pyenv; py --link-sys py35

FROM pyenv AS py36
ARG py36
RUN pyenv install ${py36}; py --link-pyenv; py --link-sys py36

FROM pyenv AS py37
ARG py37
RUN pyenv install ${py37}; py --link-pyenv; py --link-sys py37

FROM pyenv AS py38
ARG py38
RUN pyenv install ${py38}; py --link-pyenv; py --link-sys py38

FROM pyenv AS py39
ARG py39
RUN pyenv install ${py39}; py --link-pyenv; py --link-sys py39

FROM pyenv AS py310
ARG py310
RUN pyenv install ${py310}; py --link-pyenv; py --link-sys py310

FROM pyenv AS py311
ARG py311
RUN pyenv install ${py311}; py --link-pyenv; py --link-sys py311

FROM pyenv AS py312
ARG py312
RUN pyenv install ${py312}; py --link-pyenv; py --link-sys py312

FROM pyenv AS py313
ARG py313
RUN pyenv install ${py313}; py --link-pyenv; py --link-sys py313

FROM pyenv AS py314
ARG py314
RUN pyenv install ${py314}; py --link-pyenv; py --link-sys py314

FROM pyenv AS py313t
ARG py313t
# todo: use pyenv's 3.13.1t when available
COPY <<EOF ${PYENV_ROOT}/plugins/python-build/share/python-build/3.13.1t
export PYTHON_BUILD_FREE_THREADING=1
source "\$(dirname "\${BASH_SOURCE[0]}")"/3.13.1
EOF

RUN pyenv install ${py313t}; py --link-pyenv; py --link-sys py313t

FROM pyenv AS py314t
ARG py314t
RUN pyenv install ${py314t}; py --link-pyenv; py --link-sys py314t


# final

FROM pyenv AS multipython
RUN mkdir /root/.pyenv/versions
COPY --from=py27 /root/.pyenv/versions /root/.pyenv/versions/
COPY --from=py35 /root/.pyenv/versions /root/.pyenv/versions/
COPY --from=py36 /root/.pyenv/versions /root/.pyenv/versions/
COPY --from=py37 /root/.pyenv/versions /root/.pyenv/versions/
COPY --from=py38 /root/.pyenv/versions /root/.pyenv/versions/
COPY --from=py39 /root/.pyenv/versions /root/.pyenv/versions/
COPY --from=py310 /root/.pyenv/versions /root/.pyenv/versions/
COPY --from=py311 /root/.pyenv/versions /root/.pyenv/versions/
COPY --from=py312 /root/.pyenv/versions /root/.pyenv/versions/
COPY --from=py313 /root/.pyenv/versions /root/.pyenv/versions/
COPY --from=py314 /root/.pyenv/versions /root/.pyenv/versions/
COPY --from=py313t /root/.pyenv/versions /root/.pyenv/versions/
COPY --from=py314t /root/.pyenv/versions /root/.pyenv/versions/
RUN py --link-pyenv; py --link-sys py313
ARG TOX_VERSION
ARG VIRTUALENV_VERSION
RUN pip install --disable-pip-version-check --root-user-action=ignore --no-cache-dir \
        virtualenv==${VIRTUALENV_VERSION} \
        tox==${TOX_VERSION}
