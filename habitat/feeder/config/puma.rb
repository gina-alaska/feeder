workers Integer({{concurrency}})
threads_count = Integer({{threads}})
threads 1, threads_count

ENV['PUMA_PRELOAD_APP']
prune_bundler

rackup      DefaultRackup
port        Integer({{port}})
environment {{rails_env}}
pidfile     {{puma_pidfile}}
worker_timeout {{worker_timeout}}