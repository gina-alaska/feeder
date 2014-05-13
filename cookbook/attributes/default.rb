#  Assuming webapp might use this variable at some point.
default['unicorn_config_path'] = '/etc/unicorn'

default['puffin']['application_path'] = "/www/puffin"
default['puffin']['shared_path'] = "#{default['puffin']['application_path']}/shared"
default['puffin']['config_path'] = "#{default['puffin']['shared_path']}/config"
default['puffin']['initializers_path'] = "#{default['puffin']['config_path']}/initializers"
default['puffin']['deploy_path'] = "#{default['puffin']['application_path']}/current"
default['puffin']['puffin_silo_path'] = "/san/feeder_data"
default['puffin']['dragonfly_uploads_path'] = "#{default['puffin']['shared_path']}/uploads"
default['puffin']['environment'] = 'production'

default['puffin']['account'] = "webdev"

default['puffin']['database']['adapter']  = "postgresql"
default['puffin']['database']['hostname'] = "localhost"
default['puffin']['database']['database'] = "feeder_prod"
default['puffin']['database']['username'] = "feeder"
default['puffin']['database']['password'] = ""
default['puffin']['database']['search_path'] = "feeder_prod,public"

default['puffin']['sunspot']['hostname'] = "localhost"
default['puffin']['sunspot']['port'] = "8983"

default['puffin']['redis']['url'] = 'redis://localhost:6379/12'
default['puffin']['redis']['namespace'] = 'feeder_development'

default['puffin']['data'] = {
  npp: {
    host: 'nppdown.x.gina.alaska.edu:/mnt/raid/processing',
    mount: '/mnt/npp'
  },
  modis: {
    host: 'no.gina.alaska.edu:/exports/modis',
    mount: '/mnt/modis'
  },
  feeder_data: {
    host: 'feeder-vm.gina.alaska.edu:/san/feeder_data',
    mount: '/san/feeder_data'
  },
  feeder_cache: {
    host: 'feeder-vm.gina.alaska.edu:/san/feeder_cache',
    mount: '/san/feeder_cache'
  }

}

default['puffin']['sidekiq']['config'] = {
  verbose: false,
  logfile: './log/sidekiq.log',
  pidfile: './tmp/pids/sidekiq.pid',
  concurrency: 1
}

default['puffin']['before_fork'] = '
defined?(ActiveRecord::Base) and
   ActiveRecord::Base.connection.disconnect!
   
   old_pid = "#{server.config[:pid]}.oldbin"
   if old_pid != server.pid
     begin
       sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
       Process.kill(sig, File.read(old_pid).to_i)
     rescue Errno::ENOENT, Errno::ESRCH
     end
   end
      
sleep 1
'

default['puffin']['after_fork'] = "
defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
"

default['puffin']['packages'] = %w{libicu-devel curl-devel libxml2-devel libxslt-devel nfs-utils ImageMagick-devel}
