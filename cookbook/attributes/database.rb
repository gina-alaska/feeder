default['puffin']['databases']['development'] = {
  'adapter' =>  'postgresql',
  'hostname' =>  'localhost',
  'database' =>  'feeder_dev',
  'username' =>  'feeder',
  'password' =>  '',
  'search_path' =>  'feeder_dev,public',
}


#Postgresql configuration
override['postgresql']['enable_pgdg_yum'] = true
override['postgresql']['version'] = "9.2"
override['postgresql']['dir'] = "/var/lib/pgsql/9.2/data"
override['postgresql']['client']['packages'] = ["postgresql92", "postgresql92-devel"]
override['postgresql']['server']['packages'] = ["postgresql92-server"]
override['postgresql']['server']['service_name'] = "postgresql-9.2"
override['postgresql']['contrib']['packages'] = ["postgresql92-contrib"]
