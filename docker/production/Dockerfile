FROM ghcr.io/maxmind/geoipupdate:v7.0.1 AS maxmind

ENV GEOIPUPDATE_DB_DIR="/usr/share/GeoIP"
ENV GEOIPUPDATE_EDITION_IDS="GeoLite2-ASN GeoLite2-City GeoLite2-Country"
ENV GEOIPUPDATE_PRESERVE_FILE_TIMES=1

RUN --mount=type=secret,id=maxmind_account_id \
  --mount=type=secret,id=maxmind_license_key \
  GEOIPUPDATE_ACCOUNT_ID_FILE=/run/secrets/maxmind_account_id \
  GEOIPUPDATE_LICENSE_KEY_FILE=/run/secrets/maxmind_license_key \
  /usr/bin/geoipupdate

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

WORKDIR /srv/app

RUN bundle config set app_config .bundle
RUN bundle config set path .cache/bundle

ARG RAILS_ENV=production

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle \
    RACK_ENV=production \
    RAILS_ENV="${RAILS_ENV:-production}" \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    PORT=8080
ENV PATH="${BUNDLE_BIN}:${PATH}"
ENV LD_PRELOAD=libjemalloc.so.2

RUN gem update --system && gem install bundler:2.5.7

COPY Gemfile Gemfile.lock ./

RUN --mount=type=cache,id=-gem-cache,sharing=locked,target=.cache/bundle \
    bundle install -j 2 && \
    mkdir -p vendor && \
    cp -ar .cache/bundle /bundle

RUN bundle config set path /bundle

COPY . /srv/app

RUN mkdir -pv /usr/share

COPY --from=maxmind /usr/bin/geoipupdate /usr/local/bin/geoipupdate
COPY --from=maxmind /usr/share/GeoIP/ /usr/share/GeoIP

EXPOSE 8080

CMD ["bin/puma", "-C", "config/puma.rb"]
