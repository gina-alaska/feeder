include_recipe "puffin::_database_common"
include_recipe "postgresql::server"
include_recipe "database::default"
include_recipe "postgresql::ruby"

app_name = 'puffin'

postgresql_connection_info = {
	host: '127.0.0.1',
	port: 5432,
	username: 'postgres',
	password: node['postgresql']['password']['postgres']
}


# create a postgresql database
postgresql_database node[app_name]['database']['database'] do
  connection postgresql_connection_info
  action :create
end

# Create a postgresql user but grant no privileges
postgresql_database_user node[app_name]['database']['username'] do
  connection postgresql_connection_info
  password   node[app_name]['database']['password']
  action     :create
end

# Grant all privileges on all tables in foo db
postgresql_database_user node[app_name]['database']['username'] do
  connection    postgresql_connection_info
  database_name  node[app_name]['database']['database']
  privileges    [:all]
  action        :grant
end