default['puffin']['sidekiq']['mounts'] = {
  'npp' => {
    'device'      =>  'nppdown.x.gina.alaska.edu:/mnt/raid/processing',
    'fstype'      =>  'nfs',
    'mount_point' =>  '/mnt/npp',
    'options'     =>  'ro',
    'action'      =>  [:mount, :enable]
  },
  'modis' => {
    'device'      =>  'no.gina.alaska.edu:/exports/modis',
    'fstype'      =>  'nfs',
    'mount_point' =>  '/mnt/modis',
    'options'     =>  'ro',
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

default['puffin']['sidekiq']['config'] = {
  'verbose' =>  false,
  'logfile' =>  './log/sidekiq.log',
  'pidfile' =>  './tmp/pids/sidekiq.pid',
  'concurrency' =>  1
}
