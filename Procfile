resque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 bundle exec rake resque:work
web: bundle exec thin start -p $PORT
worker: bundle exec sidekiq -c 5 -v