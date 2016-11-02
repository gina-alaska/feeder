workers Integer({{cfg.concurrency}})
threads_count = Integer({{cfg.threads}})
threads 1, threads_count

ENV['PUMA_PRELOAD_APP']
prune_bundler

rackup      DefaultRackup
port        Integer({{cfg.port}})
environment "{{cfg.rails_env}}"
pidfile     "{{cfg.puma_pidfile}}"
worker_timeout {{cfg.worker_timeout}}