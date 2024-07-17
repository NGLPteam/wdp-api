FROM ruby:3.2.3-bullseye

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    gnupg gnupg2 \
    libglib2.0-0 libglib2.0-dev \
    libjemalloc2 \
    libpoppler-glib8 \
    librsvg2-bin \
    libsndfile1-dev \
    libvips \
    libvips-dev \
    mediainfo \
    postgresql-common

RUN /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends postgresql-client-15

RUN gem update --system && gem install bundler:2.5.7

WORKDIR /srv/app
COPY Gemfile /srv/app/Gemfile
COPY Gemfile.lock /srv/app/Gemfile.lock
COPY . /srv/app

COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle \
    RACK_ENV=development \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    PORT=8080
ENV PATH="${BUNDLE_BIN}:${PATH}"
ENV LD_PRELOAD=libjemalloc.so.2

EXPOSE 8080

CMD ["bin/puma", "-C", "config/puma.rb"]
