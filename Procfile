web: bin/start-pgbouncer bin/falcon -b http://0.0.0.0 -p ${PORT:-6222} -n ${WEB_CONCURRENCY:-4}
worker: bin/start-pgbouncer bin/sidekiq -C config/sidekiq.yml
