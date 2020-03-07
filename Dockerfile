FROM ruby:2.7.0-alpine3.11

RUN apk add --update --no-cache \
  build-base \
  libxml2-dev \
  libxslt-dev \
  nodejs \
  yarn \
  tzdata \
  postgresql-dev \
  && rm -rf /var/cache/apk/*

RUN apk add --no-cache --update \
  busybox-suid \
  git \
  bash \
  ca-certificates \
  wget

RUN mkdir -p /gems

RUN mkdir -p /gems
RUN chown 1000:1000 /gems

RUN addgroup -g 1000 -S app && adduser --uid 1000 -S app -G app

USER app

ENV PATH /gems/vendor/bin:$PATH
