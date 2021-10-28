FROM ruby:2.7.3-buster

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends gnupg2 libsndfile1-dev build-essential libvips-dev mediainfo ffmpeg vim

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends postgresql-client-13

RUN gem update --system && gem install bundler:2.2.16

WORKDIR /srv/app
COPY Gemfile /srv/app/Gemfile
COPY Gemfile.lock /srv/app/Gemfile.lock
COPY . /srv/app

COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

EXPOSE 6222

CMD ["bin/falcon", "-b", "http://0.0.0.0:6222", "-p", "6222"]
