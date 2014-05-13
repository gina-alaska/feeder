node.override['postgresql']['enable_pgdg_yum'] = true
node.override['postgresql']['version'] = "9.2"
node.override['postgresql']['dir'] = "/var/lib/pgsql/9.2/data"
node.override['postgresql']['client']['packages'] = ["postgresql92", "postgresql92-devel"]
node.override['postgresql']['server']['packages'] = ["postgresql92-server"]
node.override['postgresql']['server']['service_name'] = "postgresql-9.2"
node.override['postgresql']['contrib']['packages'] = ["postgresql92-contrib"]