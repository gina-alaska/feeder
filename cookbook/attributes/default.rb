#  Assuming webapp might use this variable at some point.
default['unicorn_config_path'] = '/etc/unicorn'
default['puffin']['environment'] = 'production'
default['puffin']['account'] = "webdev"
default['puffin']['ruby-version'] = "1.9.3"

default['puffin']['paths'] = {
  'application'  => '/www/puffin',
  'shared'       => '/www/puffin/shared',
  'config'       => '/www/puffin/shared/config',
  'initializers' => '/www/puffin/shared/config/initializers',
  'deploy'       => '/www/puffin/current',
  'dragonfly'    => '/www/puffin/shared/uploads'
}

default['puffin']['mounts'] = {
  'feeder_cache' => {
    'device'      =>  'feeder-vm.gina.alaska.edu:/san/feeder_cache',
    'fstype'      =>  'nfs',
    'mount_point' =>  '/san/feeder_cache',
    'options'     =>  'rw',
    'action'      =>  [:mount, :enable]
  },
  'feeder_data' => {
    'device'      =>  'feeder-vm.gina.alaska.edu:/san/feeder_data',
    'fstype'      =>  'nfs',
    'mount_point' =>  '/san/feeder_data',
    'options'     =>  'rw',
    'action'      =>  [:mount, :enable]
  }
}

default['puffin']['links'] = {
  'dragonfly' => {
    'name' => '/www/puffin/shared/public/dragonfly',
    'to'   => '/san/feeder_cache'
  }
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


override['chruby']['version'] = '0.3.8'
override['chruby']['rubies'] = {
  '1.9.3-p392' => false,
  '1.9.3-p484' => true
}
default['chruby']['default'] = 'ruby-1.9.3-p484'
