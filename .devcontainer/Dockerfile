# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.4
FROM ghcr.io/rails/devcontainer/images/ruby:$RUBY_VERSION

RUN set -ex && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
            libclang-dev \
            && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*
