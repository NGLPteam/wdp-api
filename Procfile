web: bin/start-pgbouncer bin/puma -C config/puma.rb -p ${PORT:-6222} -w ${WEB_CONCURRENCY:-2}
worker: bin/start-pgbouncer bin/sidekiq -C config/sidekiq.yml
clock: bin/zhong zhong.rb
release: bin/rake db:migrate
