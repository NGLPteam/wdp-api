FROM ruby:2.7.2
RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends libsndfile1-dev build-essential postgresql-client libvips-dev mediainfo ffmpeg

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

EXPOSE 6111

CMD ["bin/falcon", "-b", "http://0.0.0.0:6111", "-p", "6111"]
