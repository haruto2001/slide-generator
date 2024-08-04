ARG CONTAINER_VERSION=3.13.0b4-slim-bullseye
FROM python:${CONTAINER_VERSION}

ARG USERNAME=user
ARG WORKDIR=/work

ENV LANG ja_JP.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/root/.cargo/bin:$PATH"

RUN adduser --disabled-password --gecos "" ${USERNAME}
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        chromium \
        curl \
        git \
        gosu \
        libffi-dev \
        nodejs \
        npm \
        rsync \
        tmux \
        tree \
        vim \
        wget \
        zsh && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

# When installing with apt-get, nodejs and npm versions do not match
RUN npm install -g n && \
    n stable && \
    apt-get purge -y nodejs npm
RUN npm install -g @marp-team/marp-cli

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

RUN pip install poetry && \
    poetry config virtualenvs.create false

RUN mkdir ${WORKDIR}
WORKDIR ${WORKDIR}

COPY ./pyproject.toml ./poetry.lock* ./
RUN poetry install --no-dev

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

